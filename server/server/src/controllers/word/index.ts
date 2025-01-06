import { Request, Response } from "express";
import { WordAttr } from "../../models/word.model";
import { WordSrv } from "../../services/word";
namespace WordCtl {
  export async function get4RandomWords(req: Request, res: Response) {
    const rs = await WordSrv.get4RandomWords();
    res.status(200).json(rs);
  }
  export async function createMany(req: Request, res: Response) {
    const data = req.body as WordAttr[];
    const rs = await WordSrv.createMany(data);
    res.status(200).json(rs);
  }
}
export default WordCtl;
