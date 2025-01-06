import { setFlashcardModel } from "../../../models/set_flashcard.model";
import { testModel } from "../../../models/test.model";

namespace TestRepo {
  export async function checkExist(id: string) {
    const is = await testModel.findById(id);
    return !!is;
  }
  export async function addAttempt(testId: string, userId: string) {
    const result = await testModel.findOneAndUpdate(
      { _id: testId, "attempts.userId": userId },
      { $inc: { "attempts.$.times": 1 } }, // Tăng times lên 1 nếu userId đã tồn tại
      { new: true }
    );

    // Nếu `userId` chưa tồn tại, thêm `TestAttempt` mới với `times` là 1
    if (!result) {
      await testModel.findOneAndUpdate(
        { _id: testId },
        { $push: { attempts: { userId, times: 1 } } },
        { new: true, upsert: true }
      );
    }
    return 1;
  }
}
export default TestRepo;
