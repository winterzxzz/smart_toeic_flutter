import { setFlashcardModel } from "../../../models/set_flashcard.model";

namespace SetFlashcardRepo {
  export async function checkExist(id: string) {
    const is = await setFlashcardModel.findById(id);
    return !!is;
  }
}
export default SetFlashcardRepo;
