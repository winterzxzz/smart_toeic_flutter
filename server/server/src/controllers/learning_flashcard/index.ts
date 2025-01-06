import { Request, Response } from "express";

import SetFlashcardSrv from "../../services/set_flashcard";
import { LearningSetAttr } from "../../models/learning_set.model";
import LearningFlashcardSrv from "../../services/learning_flashcard";

namespace LearningFlashcardCtl {
  export async function getByLearningSet(req: Request, res: Response) {
    const { learningSetId } = req.query as { learningSetId: string };

    const set = await LearningFlashcardSrv.getByLearningSet(learningSetId);
    res.status(200).json(set);
  }

  export async function updateShortTermScore(req: Request, res: Response) {
    const { learningFlashcardId, score } = req.body as {
      learningFlashcardId: string;
      score: number;
    };

    const updated = await LearningFlashcardSrv.updateShortTermScore(
      learningFlashcardId,
      score
    );
    res.status(200).json(updated);
  }
  export async function updateSessionScore(req: Request, res: Response) {
    const data = req.body;
    const rs = await LearningFlashcardSrv.updateSessionScore(data);
    res.status(200).json(rs);
  }
}
export default LearningFlashcardCtl;
