import { Request, Response } from "express";
import ResultSrv from "../../services/result";
import { ResultAttr } from "../../models/result.model";
import ResultItemSrv from "../../services/result_item";

namespace ResultItemCtrl {
  export async function getByUser(req: Request, res: Response) {
    //@ts-ignore
    const userId = req.user.id;
    const rs = await ResultItemSrv.getByUser(userId);
    res.status(200).json(rs);
  }
  export async function getByResult(req: Request, res: Response) {
    const { resultId } = req.query;
    //@ts-ignore
    const userId = req.user.id;
    const data = {
      userId,
      resultId: resultId as string,
    };
    const rs = await ResultItemSrv.getByResult(data);
    res.status(200).json(rs);
  }
  export async function getByPart(req: Request, res: Response) {
    const { part } = req.query;
    //@ts-ignore
    const userId = req.user.id;
    const data = {
      userId,
      part: Number(part),
    };
    const rs = await ResultItemSrv.getByPart(data);
    res.status(200).json(rs);
  }
}
export default ResultItemCtrl;
