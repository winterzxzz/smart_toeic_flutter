import {
  LearningFlashcardAttr,
  learningFlashcardModel,
} from "../../../models/learning_flashcard";
import { learningSetModel } from "../../../models/learning_set.model";
import { setFlashcardModel } from "../../../models/set_flashcard.model";
import { AlgorithmsScoreFlashcard } from "../../../utils/algorithms_score_flashcard";
const DISTANCE_FACTOR = 2;
type LearningFlashcardInput = {
  flashcardId: string;
};
namespace LearningFlashcardRepo {
  export async function createMany(
    data: LearningFlashcardInput[],
    userId: string,
    setFlashcardId: string
  ) {
    const learningSet = await learningSetModel.findOne({
      setFlashcardId: setFlashcardId,
      userId,
    });
    if (!learningSet) {
      return null;
    }
    const learnignFlashcardData = data.map((item) => {
      return {
        flashcardId: item.flashcardId,
        learningSetId: learningSet.id,
      };
    });
    const rs = await learningFlashcardModel.insertMany(learnignFlashcardData);
    return rs;
  }
  export async function updateScore(data: {
    id: string;
    difficult_rate: number;
    accuracy: number;
    timeMinutes: number;
  }) {
    const { id, difficult_rate, accuracy, timeMinutes } = data;
    const now = new Date();
    const Q = accuracy * 5;
    const learningFlashcard = await learningFlashcardModel.findById(id);
    let t_actual = 0;
    if (!learningFlashcard) {
      throw new Error("Learning flashcard not found");
    }
    let last_studied;
    if (!learningFlashcard!.lastStudied) {
      last_studied = null;
    } else {
      last_studied = new Date(learningFlashcard!.lastStudied);
    }
    let algorithmsScoreFlashcard;
    if (!last_studied) {
      algorithmsScoreFlashcard = new AlgorithmsScoreFlashcard(
        1,
        0,
        learningFlashcard.EF,
        Q,
        timeMinutes,
        accuracy,
        learningFlashcard.retentionScore || 1,
        learningFlashcard.interval || 0,
        difficult_rate
      );
    } else {
      t_actual =
        (now.getTime() - last_studied.getTime()) / (1000 * 60 * 60 * 24);
      algorithmsScoreFlashcard = new AlgorithmsScoreFlashcard(
        learningFlashcard!.studyTime + 1,
        t_actual,
        learningFlashcard?.EF,
        Q,
        timeMinutes,
        accuracy,
        learningFlashcard.retentionScore || 1,
        learningFlashcard.interval || 0,
        difficult_rate
      );
    }
    let isCountNextOptimalTime = false;
    if (
      !learningFlashcard.interval ||
      (t_actual && t_actual / (learningFlashcard.interval || 0.1) > 0.8)
    ) {
      isCountNextOptimalTime = true;
    }

    const optimalDateNext = new Date(
      now.getTime() +
        algorithmsScoreFlashcard.calculateOptimalTime() * 1000 * 60 * 60 * 24
    );

    const newLearningFlashcard = await learningFlashcardModel.findByIdAndUpdate(
      id,
      {
        studyTime: learningFlashcard!.studyTime + 1,
        lastStudied: now,
        EF: algorithmsScoreFlashcard.calculateEF(),
        retentionScore: algorithmsScoreFlashcard.calculateMemoryRetention(),
        decayScore: algorithmsScoreFlashcard.calculateDecay(),
        optimalTime: isCountNextOptimalTime
          ? optimalDateNext
          : learningFlashcard!.optimalTime,
        interval: isCountNextOptimalTime
          ? algorithmsScoreFlashcard.calculateOptimalTime()
          : learningFlashcard!.interval,
      }
    );
    return newLearningFlashcard;
  }
}
export default LearningFlashcardRepo;
