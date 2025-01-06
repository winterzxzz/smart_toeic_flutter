import { BadRequestError } from "../../errors/bad_request_error";
import {
  ResultItemAttr,
  resultItemModel,
} from "../../models/result_item.model";
import TestRepo from "../test/repos";

namespace ResultItemSrv {
  export async function getByUser(userId: string) {
    const rs = await resultItemModel.find({
      userId,
    });
    return rs;
  }
  export async function getByResult(data: {
    resultId: string;
    userId: string;
  }) {
    if (!data.userId) {
      throw new BadRequestError("userId phải được cung cấp!");
    }
    if (!data.resultId) {
      throw new BadRequestError("resultId phải được cung cấp!");
    }
    const rs = await resultItemModel.find({
      userId: data.userId,
      resultId: data.resultId,
    });
    return rs;
  }
  export async function getByPart(data: { part: number; userId: string }) {
    if (!data.part) {
      throw new BadRequestError("part phải được cung cấp dưới dạng số!");
    }
    const rs = await resultItemModel.find({
      userId: data.userId,
      part: data.part,
    });
    return rs;
  }
  export async function create(data: ResultItemAttr) {
    const isExist = await TestRepo.checkExist(data.testId);
    if (!isExist) {
      throw new BadRequestError("Bài test không tồn tại.");
    }
    const newResultItem = await resultItemModel.create(data);
    return newResultItem;
  }
}
export default ResultItemSrv;
