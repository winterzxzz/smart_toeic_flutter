import { WordAttr } from "../../models/word.model";

import { wordModel } from "../../models/word.model";

export namespace WordSrv {
  export async function create(data: WordAttr) {
    const newWord = await wordModel.create(data);
    return newWord;
  }
  export async function get4RandomWords() {
    const rs = await wordModel.aggregate([{ $sample: { size: 4 } }]);
    const transformedResult = rs.map(({ _id, ...rest }) => ({
      id: _id,
      ...rest,
    }));

    return transformedResult;
  }
  export async function createMany(data: WordAttr[]) {
    const rs = await wordModel.insertMany(data);
    return rs;
  }
}
