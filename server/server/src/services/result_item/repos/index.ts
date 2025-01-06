import {
  ResultItemAttr,
  resultItemModel,
} from "../../../models/result_item.model";

namespace ResultItemRepo {
  export async function checkExist(id: string) {
    const is = await resultItemModel.findById(id);
    return !!is;
  }
  export async function createMany(resultItems: ResultItemAttr[]) {
    const rs = await resultItemModel.insertMany(resultItems);
    return rs;
  }
  export async function deleteMany(resultId: string) {
    const rs = await resultItemModel.deleteMany({ resultId });
    return rs;
  }
}
export default ResultItemRepo;
