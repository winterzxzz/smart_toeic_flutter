import { resultModel } from "../../../models/result.model";
import { setFlashcardModel } from "../../../models/set_flashcard.model";

namespace ResultRepo {
  export async function checkExist(id: string) {
    const is = await resultModel.findById(id);
    return !!is;
  }
}
export default ResultRepo;
