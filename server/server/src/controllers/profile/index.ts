import { Request, Response } from "express";
import ResultSrv from "../../services/result";
import { ResultAttr } from "../../models/result.model";
import ProfileService from "../../services/profile";

namespace ProfileCtrl {
  export async function getAnalyst(req: Request, res: Response) {
    const n = req.query.numOfDays ? Number(req.query.numOfDays) : 7;
  
    // @ts-ignore
    const userId = req.user!.id;
    const rs = await ProfileService.getAnalyst(userId);
    res.status(200).json(rs);
  }
  export async function getSuggestForStudy(req: Request, res: Response) {
    // @ts-ignore
    const userId = req.user!.id;
    const rs = await ProfileService.getSuggestForStudy(userId);
    res.status(200).json(rs);
  }
}
export default ProfileCtrl;
