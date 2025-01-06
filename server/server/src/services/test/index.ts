import mongoose from "mongoose";
import { TestAttr, testModel } from "../../models/test.model";
import { result } from "lodash";
import { resultModel } from "../../models/result.model";
import * as XLSX from "xlsx";
import { cleanNullFieldObject } from "../../utils";
import { ORIGIN } from "../../configs";
import { userModel } from "../../models/user.model";
function getImage(name: string, code: string) {
  if (!name || name === "") {
    return null;
  }
  return ORIGIN + `/uploads/images/${code}/${name}.jpg`;
}
function getAudio(name: string, code: string) {
  if (!name || name === "") {
    return null;
  }
  return ORIGIN + `/uploads/audios/${code}/${name}.mp3`;
}
namespace TestSrv {
  export async function create(data: TestAttr) {
    const newTest = await testModel.create(data);
    return newTest;
  }
  export async function getAll(userId?: string) {
    if (!userId) {
      const rs = await testModel.find({}).limit(3);
      return rs;
    }
    const tests = await testModel.find({}).lean();

    const markedTests = await Promise.all(
      tests.map(async (test) => {
        const userAttempt = test.attempts.find(
          (attempt: { userId: string }) => attempt.userId === userId
        );
        if (!userAttempt) {
          return {
            ...test,
            id: test._id,
            userAttempt: null,
          };
        }
        const result = await resultModel
          .findOne({
            userId: userId,
            testId: test._id,
          })
          .sort({ createdAt: -1 })
          .lean();
        const resultAll = await resultModel
          .find({
            userId: userId,
            testId: test._id,
          })
          .lean();
        const count = resultAll.length;
        return {
          ...test,
          userAttempt: {
            ...userAttempt,
            lastSubmit: result?.createdAt,
            timeSubmit: count,
          },
          id: test._id,
        };
      })
    );
    return markedTests;
  }
  export async function getByCode(code: string) {
    const rs = await testModel.findOne({
      code: code,
    });
    return rs;
  }
  export async function getById(id: string) {
    const rs = await testModel.findById(id);
    return rs;
  }
  // export async function getByQuery(
  //   query: {
  //     id?: string;
  //     limit: number;
  //     skip: number;
  //   },
  //   userId?: string
  // ) {
  //   let { skip = 0, limit = 3, ...filters } = query;
  //   skip = Number(skip);
  //   limit = Number(limit);
  //   let isGetPublished = true;
  //   if (userId) {
  //     const admin = await userModel.findOne({
  //       id: userId,
  //       role: "admin",
  //     });
  //     if (admin) {
  //       isGetPublished = false;
  //     }
  //   }
  //   const pipeline: any[] = [
  //     // 1. Match điều kiện lọc
  //     {
  //       $match: {
  //         ...(filters.id
  //           ? { _id: new mongoose.Types.ObjectId(filters.id) }
  //           : {}),
  //         ...(isGetPublished ? { isPublished: true } : {}),
  //       },
  //     },
  //     // 2. Sort giảm dần theo `createdAt`
  //     {
  //       $sort: { createdAt: -1 },
  //     },
  //     // 3. Skip và Limit cho phân trang
  //     {
  //       $skip: skip,
  //     },
  //     {
  //       $limit: limit,
  //     },
  //     // 4. Thêm trường `isAttempted` dựa trên userId (nếu có)
  //     ...(userId
  //       ? [
  //           {
  //             $addFields: {
  //               isAttempted: {
  //                 $anyElementTrue: {
  //                   $map: {
  //                     input: "$attempts",
  //                     as: "attempt",
  //                     in: { $eq: ["$$attempt.userId", userId] },
  //                   },
  //                 },
  //               },
  //             },
  //           },
  //         ]
  //       : []),
  //     // 5. Chuyển `_id` thành `id` và loại bỏ các trường không cần thiết
  //     {
  //       $project: {
  //         id: "$_id",
  //         _id: 0,
  //         title: 1,
  //         url: 1,
  //         type: 1,
  //         attempts: 1,
  //         code: 1,
  //         numberOfParts: 1,
  //         numberOfQuestions: 1,
  //         duration: 1,
  //         fileName: 1,
  //         parts: 1,
  //         createdAt: 1,
  //         isAttempted: 1, // Nếu userId không tồn tại, trường này sẽ không được thêm
  //         isPublished: 1,
  //         difficulty: 1,
  //       },
  //     },
  //   ];

  //   // Thực thi pipeline
  //   const result = await testModel.aggregate(pipeline);
  //   return result;
  // }
  export async function getByQuery(
    query: {
      id?: string;
      limit: number;
      skip: number;
    },
    userId?: string
  ) {
    let { skip = 0, limit = 4, ...filters } = query;
    skip = Number(skip);
    limit = Number(limit);
    const pipeline: any[] = [
      // Stage 1: Lookup để join với collection results
      {
        $lookup: {
          from: "results",
          localField: "_id",
          foreignField: "testId",
          as: "results",
        },
      },

      // Stage 2: Thêm trường attemptCount và userAttempt
      {
        $addFields: {
          attemptCount: { $size: "$results" },
          userAttempt: {
            $let: {
              vars: {
                userResults: {
                  $filter: {
                    input: "$results",
                    as: "result",
                    cond: {
                      $eq: [
                        "$$result.userId",
                        userId ? new mongoose.Types.ObjectId(userId) : null,
                      ],
                    },
                  },
                },
              },
              in: {
                count: { $size: "$$userResults" },
                lastTime: {
                  $max: "$$userResults.createdAt",
                },
              },
            },
          },
        },
      },

      // Stage 3: Project để chọn các trường cần thiết và format
      {
        $project: {
          _id: 0,
          id: "$_id",
          title: 1,
          type: 1,
          code: 1,
          parts: 1,
          numberOfParts: 1,
          numberOfQuestions: 1,
          duration: 1,
          difficulty: 1,
          isPublished: 1,
          attemptCount: 1,
          userAttempt: 1,
          createdAt: 1,
          updatedAt: 1,
        },
      },

      // Stage 4: Sort theo số lượt làm bài
      {
        $sort: { attemptCount: -1 },
      },
    ];

    // Thêm $skip và $limit nếu có
    if (skip) {
      pipeline.push({ $skip: skip });
    }
    if (limit) {
      pipeline.push({ $limit: limit });
    }

    // Thêm $match cho id cụ thể nếu có
    if (query.id) {
      pipeline.unshift({
        $match: { _id: new mongoose.Types.ObjectId(query.id) },
      });
    }

    // Thực hiện query
    const tests = await testModel.aggregate(pipeline);

    return tests;
  }
  export async function updateAll(updateData: object) {
    const rs = await testModel.updateMany(
      {}, // Filter criteria
      { ...updateData } // Data to update
    );
    return rs;
  }
  export async function handleExcel(id: string) {
    const rs = await testModel.findById(id);
    if (!rs) {
      throw new Error("Test not found");
    }
    const linkExcel = `http://localhost:4000/uploads/excels/${rs.code}/${rs.fileName}`;
    const response = await fetch(linkExcel);
    const arrayBuffer = await response.arrayBuffer();
    const workbook = XLSX.read(arrayBuffer, { type: "array" });
    const worksheet = workbook.Sheets[workbook.SheetNames[0]];
    const jsonData = XLSX.utils.sheet_to_json(worksheet, {
      header: 1,
      defval: "",
    });
    const list = [];
    if (jsonData.length > 1) {
      const header = jsonData[0] as string[];
      for (let i = 1; i < jsonData.length; i++) {
        const arr = jsonData[i] as string[];
        const questionItem = {
          id: arr[0],
          [header[0]]: arr[0] || null,
          [header[1]]: arr[1] || null,
          [header[2]]: arr[2] || null,
          [header[3]]: arr[3] || null,
          [header[4]]: arr[4] || null,
          [header[5]]: arr[5] || null,
          [header[6]]: arr[6] || null,
          [header[7]]: arr[7] || null,
          [header[8]]: arr[8] || null,
          [header[9]]: arr[9] || null,
        };
        questionItem.image = getImage(questionItem.image || "", rs.code);
        questionItem.audio = getAudio(questionItem.audio || "", rs.code);
        const filteredQuestionItem = cleanNullFieldObject(questionItem);
        const options = [arr[5], arr[6], arr[7], arr[8]];
        const labels = ["A", "B", "C", "D"];
        // @ts-ignore
        filteredQuestionItem.options = options
          .map((op, index) => {
            if (!op) {
              return null;
            }
            return {
              id: labels[index],
              content: op,
            };
          })
          .filter((option) => option !== null);
        list.push(filteredQuestionItem);
      }
    }
    return list;
  }
}
export default TestSrv;
