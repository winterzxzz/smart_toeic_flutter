import { userSetFlashcardModel } from "../../../models/user_set_flashcard.model";

namespace UserSetFlashcardRepo {
  export async function checkExist(id: string) {
    const is = await userSetFlashcardModel.findById(id);
    return !!is;
  }
}
export default UserSetFlashcardRepo;
