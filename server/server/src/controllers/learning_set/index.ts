import { Request, Response } from "express";

import SetFlashcardSrv from "../../services/set_flashcard";
import { LearningSetAttr } from "../../models/learning_set.model";
import LearningSetSrv from "../../services/learning_set";

namespace LearningSetCtl {
  export async function addSetToLearn(req: Request, res: Response) {
    const data = req.body as LearningSetAttr;
    //@ts-ignore
    data.userId = req.user!.id;
    const setFlashcard = await LearningSetSrv.addSetToLearn(data);
    res.status(200).json(setFlashcard);
  }
  export async function removeSetFromLearn(req: Request, res: Response) {
    const { learningSetId } = req.body;
    //@ts-ignore
    const userId = req.user!.id;
    const rs = await LearningSetSrv.removeSetFromLearn(userId, learningSetId);
    res.status(200).json(rs);
  }
  export async function getLearningSetByUser(req: Request, res: Response) {
    //@ts-ignore
    const userId = req.user!.id;
    const rs = await LearningSetSrv.getLearningSetByUser(userId);
    res.status(200).json(rs);
  }

  export async function getLearningSetBySetId(req: Request, res: Response) {
    const { setFlashcardId } = req.query as { setFlashcardId: string };
    const rs = await LearningSetSrv.getLearningSetBySetId(setFlashcardId);
    res.status(200).json(rs);
  }
  export async function getLearningSetById(req: Request, res: Response) {
    const { id } = req.query as { id: string };
    const rs = await LearningSetSrv.getLearningSetById(id);
    res.status(200).json(rs);
  }
}
export default LearningSetCtl;
