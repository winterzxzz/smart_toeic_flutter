import { Request, Response } from "express";
import { FlashcardAttr, FlashcardModel } from "../../models/flashcard.model";
import FlashCardSrv from "../../services/flashcard";

namespace FlashCardCtrl {
  export async function create(req: Request, res: Response) {
    const data = req.body as FlashcardAttr;
    //@ts-ignore
    const userId = req.user!.id;
    const flashcard = await FlashCardSrv.create(req.body, userId);
    res.status(200).json(flashcard);
  }
  export async function createMany(req: Request, res: Response) {
    const data = req.body as FlashcardAttr[];
    //@ts-ignore
    const userId = req.user!.id;
    const flashcard = await FlashCardSrv.createMany(data, userId);
    res.status(200).json(flashcard);
  }
  export async function getBySet(req: Request, res: Response) {
    const { setFlashcardId } = req.query;
    //@ts-ignore
    const userId = req.user!.id;
    const d = setFlashcardId as string;
    const flashcard = await FlashCardSrv.getBySet(d, userId);
    res.status(200).json(flashcard);
  }
  export async function update(req: Request, res: Response) {
    const { id, ...data } = req.body;

    const query = {
      id: id as string,
      //@ts-ignore
      userId: req.user!?.id as string,
    };
    const flashcard = await FlashCardSrv.update(query, data);
    res.status(200).json(flashcard);
  }

  export async function remove(req: Request, res: Response) {
    const { id, setFlashcardId } = req.body;
    const data = {
      id,
      setFlashcardId,
      //@ts-ignore
      userId: req.user!.id,
    };
    const flashcard = await FlashCardSrv.remove(data);
    res.status(200).json(flashcard);
  }
}
export default FlashCardCtrl;
