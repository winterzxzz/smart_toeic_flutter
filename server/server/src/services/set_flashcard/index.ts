import { Role } from "../../configs/enum";
import { NotFoundError } from "../../errors/not_found_error";
import { flashcardModel } from "../../models/flashcard.model";
import {
  SetFlashcardAttr,
  setFlashcardModel,
} from "../../models/set_flashcard.model";
import { userModel } from "../../models/user.model";

namespace SetFlashcardSrv {
  export async function create(data: SetFlashcardAttr) {
    const user = await userModel.findById(data.userId);
    data.userRole = user?.role || Role.user;
    if (data.userRole === Role.user) {
      data.isPublic = false;
    }
    const newSet = await setFlashcardModel.create(data);
    return newSet;
  }
  export async function getByUser(userId: string) {
    const rs = await setFlashcardModel.find({
      userId: userId,
    });
    return rs;
  }
  export async function getPublic() {
    const rs = await setFlashcardModel.find({
      isPublic: true,
    });
    return rs;
  }
  export async function getById(data: { id: string; userId?: string }) {
    let rs;
    if (!data.userId) {
      rs = await setFlashcardModel.findOne({
        _id: data.id,
        isPublic: true,
      });
    }
    rs = await setFlashcardModel.findOne({
      userId: data.userId,
      _id: data.id,
    });

    if (!rs) {
      throw new NotFoundError("Không thể truy cập bộ flashcard này");
    }

    return rs;
  }
  export async function remove(data: { id: string; userId: string }) {
    const rs = await setFlashcardModel.findByIdAndDelete({
      _id: data.id,
      userId: data.userId,
    });
    if (rs) {
      const fls = await flashcardModel.deleteMany({
        setFlashcardId: rs._id,
      });
    }
    return rs;
  }
  export async function update(data: {
    id: string;
    title: string;
    description: string;
    userId: string;
  }) {
    const rs = await setFlashcardModel.findByIdAndUpdate(
      { _id: data.id, userId: data.userId },
      data,
      {
        new: true,
      }
    );
    return rs;
  }
}
export default SetFlashcardSrv;
