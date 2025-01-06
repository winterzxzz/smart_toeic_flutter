import { BadRequestError } from "../../errors/bad_request_error";
import { NotFoundError } from "../../errors/not_found_error";
import { FlashcardAttr, FlashcardModel } from "../../models/flashcard.model";
import { ResultAttr, resultModel } from "../../models/result.model";
import { ResultItemAttr } from "../../models/result_item.model";
import { testModel } from "../../models/test.model";
import { formatDate, getStartOfPeriod } from "../../utils";
import ResultItemRepo from "../result_item/repos";
import SetFlashcardUtil from "../set_flashcard/repos";
import TestSrv from "../test";
import TestRepo from "../test/repos";
import UserRepo from "../user/repos";

namespace ResultSrv {
  export async function create(data: ResultAttr) {
    const isExist = await TestRepo.checkExist(data.testId);
    if (!isExist) {
      throw new BadRequestError("Bài test không tồn tại.");
    }
    const newResult = await resultModel.create(data);
    return newResult;
  }
  export async function creataWithItems(data: {
    rs: ResultAttr;
    rsis: ResultItemAttr[];
  }) {
    const test = await testModel.findById(data.rs.testId);
    if (!test) {
      throw new BadRequestError("Bài test không tồn tại.");
    }
    data.rs.testType = test.type;
    data.rs.numberOfUserAnswers = data.rsis.length;
    data.rs.numberOfCorrectAnswers = data.rsis.filter((item) => {
      return item.useranswer === item.correctanswer;
    }).length;
    const newResult = await resultModel.create(data.rs); // result
    let rsItems;

    if (newResult) {
      rsItems = data.rsis.map((item) => {
        return {
          ...item,
          resultId: newResult.id,
          testId: data.rs.testId,
          testType: data.rs.testType,
          userId: data.rs.userId,
        };
      }) as ResultItemAttr[];
    }
    console.log(rsItems);
    const newResults = await ResultItemRepo.createMany(rsItems!);
    await TestRepo.addAttempt(data.rs.testId, data.rs.userId);
    return newResult;
  }
  export async function getByUser(data: {
    userId: string;
    limit?: number;
    skip?: number;
  }) {
    const isExist = await UserRepo.checkExist(data.userId);
    if (!isExist) {
      throw new BadRequestError("Người dùng không tồn tại");
    }
    const result = await resultModel
      .find({
        userId: data.userId,
      })
      .populate("testId")
      .sort({ createdAt: -1 })
      .skip(data.skip || 0)
      .limit(data.limit || 3);
    return result;
  }
  export async function getByTest(data: {
    userId: string;
    testId: string;
    limit?: number;
    skip?: number;
  }) {
    if (!data.testId) {
      throw new NotFoundError("TestId phải được cung cấp");
    }
    if (!data.userId) {
      throw new NotFoundError("UserId phải được cung cấp");
    }
    const rs = await resultModel
      .find({
        userId: data.userId,
        testId: data.testId,
      })
      .populate("testId")
      .sort({ createdAt: -1 })
      .skip(data.skip || 0)
      .limit(data.limit || 3);
    return rs;
  }
  export async function getById(data: { userId: string; id?: string }) {
    if (!data.id) {
      throw new NotFoundError("Id phải được cung cấp");
    }
    if (!data.userId) {
      throw new NotFoundError("UserId phải được cung cấp");
    }
    const rs = await resultModel.findOne({
      userId: data.userId,
      _id: data.id,
    });
    return rs;
  }
  export async function deleteById(data: { userId: string; id?: string }) {
    if (!data.id) {
      throw new NotFoundError("Id phải được cung cấp");
    }
    if (!data.userId) {
      throw new NotFoundError("UserId phải được cung cấp");
    }
    const rs = await resultModel.deleteOne({
      userId: data.userId,
      _id: data.id,
    });
    await ResultItemRepo.deleteMany(data.id);
    return rs;
  }
  export async function getNewResultAnalyst(step: number, num: number) {
    // Lấy ngày hiện tại
    const currentDate = new Date();

    // Tính ngày bắt đầu
    const startDate = new Date(currentDate);
    startDate.setDate(currentDate.getDate() - step * num);
    const periodStart = getStartOfPeriod(startDate, step);

    const result = await resultModel.aggregate([
      {
        // Lọc các transaction từ startDate
        $match: {
          createdAt: { $gte: periodStart },
        },
      },
      {
        // Thêm trường period để nhóm
        $addFields: {
          periodStart: {
            $subtract: [
              { $toDate: "$createdAt" },
              {
                $mod: [
                  { $subtract: [{ $toDate: "$createdAt" }, periodStart] },
                  step * 24 * 60 * 60 * 1000,
                ],
              },
            ],
          },
        },
      },
      {
        // Nhóm theo period và tính tổng amount
        $group: {
          _id: "$periodStart",
          count: { $sum: 1 },
        },
      },
      {
        // Sắp xếp theo thời gian
        $sort: {
          _id: 1,
        },
      },
    ]);

    // Format lại kết quả và tính growth rate
    const formattedResult = [];
    let currentPeriod = new Date(periodStart);
    let previousAmount = null;

    for (let i = 0; i < num; i++) {
      const periodEnd = new Date(currentPeriod);
      periodEnd.setDate(periodEnd.getDate() + step - 1);

      // Tìm data tương ứng trong result
      const periodData = result.find(
        (item) => item._id.getTime() === currentPeriod.getTime()
      );

      const currentCount = periodData ? periodData.count : 0;

      // Tính growth rate
      let growthRate = null;
      if (previousAmount !== null && previousAmount !== 0) {
        growthRate = ((currentCount - previousAmount) / previousAmount) * 100;
      } else if (previousAmount === 0 && currentCount !== 0) {
        growthRate = 100;
      } else if (previousAmount === 0 && currentCount === 0) {
        growthRate = 0;
      }

      formattedResult.push({
        period: `${formatDate(currentPeriod)} - ${formatDate(periodEnd)}`,
        startDate: currentPeriod.toISOString(),
        endDate: periodEnd.toISOString(),
        totalAmount: currentCount,
        count: periodData ? periodData.count : 0,
        growthRate: growthRate !== null ? Number(growthRate.toFixed(2)) : null, // Làm tròn đến 2 chữ số thập phân
        previousAmount: previousAmount, // Optional, có thể bỏ nếu không cần
      });

      // Lưu lại amount hiện tại để tính growth rate cho period tiếp theo
      previousAmount = currentCount;

      // Chuyển sang period tiếp theo
      currentPeriod.setDate(currentPeriod.getDate() + step);
    }

    return formattedResult;
  }
  export async function getUserProgressAnalyst(step: number, num: number) {
    const totalResult = await resultModel.countDocuments();
    return {
      totalResult,
    };
  }
}
export default ResultSrv;
