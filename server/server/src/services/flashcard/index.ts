import { BadRequestError } from "../../errors/bad_request_error";
import { NotFoundError } from "../../errors/not_found_error";
import {
  FlashcardAttr,
  FlashcardDoc,
  flashcardModel,
} from "../../models/flashcard.model";
import { setFlashcardModel } from "../../models/set_flashcard.model";
import LearningFlashcardRepo from "../learning_flashcard/repos";
import SetFlashcardUtil from "../set_flashcard/repos";

namespace FlashCardSrv {
  export async function getBySet(setFlashcardId: string, userId: string) {
    const isSetExist = await setFlashcardModel.findOne({
      _id: setFlashcardId,
      userId: userId,
    });
    if (!isSetExist) {
      throw new BadRequestError("Set flashcard not exist.");
    }
    const rs = await flashcardModel
      .find({
        setFlashcardId: setFlashcardId,
      })
      .sort({ createdAt: -1 });
    return rs;
  }
  export async function create(data: FlashcardAttr, userId: string) {
    const isSetExist = await setFlashcardModel.findOne({
      _id: data.setFlashcardId,
      userId: userId,
    });
    if (!isSetExist) {
      throw new BadRequestError("Set flashcard not exist.");
    }
    const newCard = await flashcardModel.create(data);
    await LearningFlashcardRepo.createMany(
      [{ flashcardId: newCard.id }],
      userId,
      data.setFlashcardId
    );
    await setFlashcardModel.updateOne(
      { _id: data.setFlashcardId, userId: userId },
      { $inc: { numberOfFlashcards: 1 } }
    );
    return newCard;
  }
  export async function createMany(
    data: FlashcardAttr[] | undefined,
    userId: string
  ) {
    if (!data) {
      throw new BadRequestError("Dữ liệu truyền vào trống");
    }
    if (data!.length === 0) {
      throw new BadRequestError("Dữ liệu truyền vào trống");
    }
    const setFlashcardId = data[0].setFlashcardId;
    const isSetExist = await setFlashcardModel.findOne({
      _id: setFlashcardId,
      userId: userId,
    });
    const dataUser = data.map((item) => {
      return { ...item, userId: userId };
    });
    if (!isSetExist) {
      throw new BadRequestError("Set flashcard not exist.");
    }
    const newCards = await flashcardModel.insertMany(dataUser);
    await setFlashcardModel.updateOne(
      { _id: setFlashcardId, userId: userId },
      { $inc: { numberOfFlashcards: dataUser.length } }
    );
    return newCards;
  }
  export async function remove(data: { id: string; userId: string }) {
    const fc = await flashcardModel.findById(data.id);
    if (!fc) {
      throw new NotFoundError("Flashcard này không tồn tại");
    }
    const isSetExist = await setFlashcardModel
      .findOne({
        _id: fc?.setFlashcardId,
        userId: data.userId,
      })
      .lean();
    if (!isSetExist) {
      throw new BadRequestError("Set flashcard not exist.");
    }

    // Xóa flashcard
    await flashcardModel.deleteOne({
      _id: data.id,
    });

    // Giảm numberOfFlashcards trong set flashcard
    await setFlashcardModel.updateOne(
      { _id: fc.setFlashcardId, userId: data.userId },
      { $inc: { numberOfFlashcards: -1 } }
    );

    return { message: "Flashcard removed successfully." };
  }
  export async function update(
    query: { id: string; userId: string },
    data: FlashcardAttr
  ) {
    const fc = await flashcardModel.findById(query.id);
    if (!fc) {
      throw new NotFoundError("Flashcard này không tồn tại");
    }
    const isSetExist = await setFlashcardModel.findOne({
      _id: fc.setFlashcardId,
      userId: query.userId,
    });
    if (!isSetExist) {
      throw new BadRequestError("Set flashcard not exist.");
    }
    const rs = await flashcardModel.findOneAndUpdate(
      { _id: query.id, setFlashcardId: fc.setFlashcardId },
      { $set: data },
      { new: true } // Trả về tài liệu đã cập nhật
    );
    if (!rs) {
      throw new BadRequestError("Something wrong");
    }
    return rs;
  }
}

export default FlashCardSrv;
