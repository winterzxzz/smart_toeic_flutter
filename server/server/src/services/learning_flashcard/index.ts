import { learningFlashcardModel } from "../../models/learning_flashcard";
import LearningFlashcardRepo from "./repos";
type DataUpdateScore = {
  id: string;
  accuracy: number;
  difficult_rate: number; // 0 - 1 khó = 1, dễ = 0
  timeMinutes: number;
};
namespace LearningFlashcardSrv {
  // Add a set to the user's learning list

  export async function getByLearningSet(learningSetId: string) {
    const result = await learningFlashcardModel
      .find({
        learningSetId: learningSetId,
      })
      .populate("flashcardId")
      .sort({ createdAt: -1 });
    if (!result) {
      throw new Error("Set not found in the learning list.");
    }

    return result;
  }

  export async function updateShortTermScore(
    learningFlashcardId: string,
    score: number
  ) {
    const result = await learningFlashcardModel.findByIdAndUpdate(
      { _id: learningFlashcardId },
      {
        shortTermScore: score,
      },
      { new: true }
    );

    return result;
  }
  export async function updateSessionScore(data: DataUpdateScore[]) {
    const a = await Promise.all(
      data.map((item) => {
        return LearningFlashcardRepo.updateScore(item);
      })
    );
    return a;
  }
}

export default LearningFlashcardSrv;
