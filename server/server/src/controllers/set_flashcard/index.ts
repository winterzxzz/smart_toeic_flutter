import { Request, Response } from "express";
import { BadRequestError } from "../../errors/bad_request_error";
import { FlashcardAttr, FlashcardModel } from "../../models/flashcard.model";
import FlashCardSrv from "../../services/flashcard";
import { SetFlashcardAttr } from "../../models/set_flashcard.model";
import SetFlashcardSrv from "../../services/set_flashcard";

namespace SetFlashcardCtrl {
  export async function create(req: Request, res: Response) {
    const data = req.body as SetFlashcardAttr;
    data.userId = req.user!.id;
    const setFlashcard = await SetFlashcardSrv.create(req.body);
    res.status(200).json(setFlashcard);
  }
  export async function getById(req: Request, res: Response) {
    const data = {
      userId: req?.user?.id,
      id: req.query.id as string,
    };
    const rs = await SetFlashcardSrv.getById(data);
    res.status(200).json(rs);
  }
  export async function getByUser(req: Request, res: Response) {
    const userId = req.user!.id;
    const rs = await SetFlashcardSrv.getByUser(userId);
    res.status(200).json(rs);
  }
  export async function getPublic(req: Request, res: Response) {
    const rs = await SetFlashcardSrv.getPublic();
    res.status(200).json(rs);
  }
  export async function remove(req: Request, res: Response) {
    const data = req.body as { id: string; userId: string };
    // @ts-ignore
    data.userId = req.user!.id;
    const rs = await SetFlashcardSrv.remove(data);
    res.status(200).json(rs);
  }
  export async function update(req: Request, res: Response) {
    const data = req.body as {
      id: string;
      title: string;
      description: string;
      userId: string;
    };
    const rs = await SetFlashcardSrv.update(data);
    res.status(200).json(rs);
  }
}
export default SetFlashcardCtrl;
