import express from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import DashboardAnalysisController from "../../../controllers/dashboard_analysis";

const adminAnalysisRouter = express.Router();

adminAnalysisRouter.get(
  "/new-user",
  handleAsync(DashboardAnalysisController.getNewUserWithinNDays)
);
adminAnalysisRouter.get(
  "/exam-attempt",
  handleAsync(DashboardAnalysisController.examAttemptWithinNDays)
);
adminAnalysisRouter.get(
  "/income",
  handleAsync(DashboardAnalysisController.getIncomeWithinNDays)
);

export default adminAnalysisRouter;
