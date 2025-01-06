import { Request, Response } from "express";
import {
  getNewUserWithinNDaysSrv,
  examAttemptWithinNDaysSrv,
  getIncomeWithinNDaysSrv,
} from "../../services/dashboard_analysis";

namespace DashboardAnalysisController {
  export async function getNewUserWithinNDays(req: Request, res: Response) {
    const { n } = req.query;
    const nDays = Number(n);
    const users = await getNewUserWithinNDaysSrv(nDays);
    const data = {
      ...users,
      message: "Number of new users within " + nDays + " days  ",
    };
    res.status(200).json({ user: data });
  }
  export async function examAttemptWithinNDays(req: Request, res: Response) {
    const { n } = req.query;
    const nDays = Number(n);
    const exams = await examAttemptWithinNDaysSrv(nDays);
    const data = {
      ...exams,
      message: "Number of exam attempts within " + nDays + " days  ",
    };
    res.status(200).json({ exam: data });
  }
  export async function getIncomeWithinNDays(req: Request, res: Response) {
    const { n } = req.query;
    const nDays = Number(n);
    const income = await getIncomeWithinNDaysSrv(nDays);
    const data = {
      ...income,
      message: "Number of income within " + nDays + " days  ",
    };
    res.status(200).json({ income: data });
  }
}
export default DashboardAnalysisController;
