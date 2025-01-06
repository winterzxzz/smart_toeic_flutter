import { NotFoundError } from "../../errors/not_found_error";
import {
  SetFlashcardAttr,
  setFlashcardModel,
} from "../../models/set_flashcard.model";
import {
  UserSetFlashcardAttr,
  userSetFlashcardModel,
} from "../../models/user_set_flashcard.model";
import SetFlashcardRepo from "../set_flashcard/repos";
import UserRepo from "../user/repos";

namespace UserSetFlashcardSrv {
  export async function create(data: UserSetFlashcardAttr) {
    const isSetFCExist = await SetFlashcardRepo.checkExist(data.setFlashcardId);
    const isUserExist = await UserRepo.checkExist(data.userId);
    if (isUserExist) {
      throw new NotFoundError("Người dùng không tồn tại");
    }
    if (!isSetFCExist) {
      throw new NotFoundError("Bộ flashcard không tồn tại");
    }
    const newSet = await userSetFlashcardModel.create(data);
    return newSet;
  }
  export async function getByUser(userId: string) {
    const rs = await userSetFlashcardModel.find({
      userId: userId,
    });
    return rs;
  }
}
export default UserSetFlashcardSrv;
