import express from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import ResultCtrl from "../../../controllers/result";

const adminResultRouter = express.Router();

adminResultRouter.get(
  "/analyst/new",
  handleAsync(ResultCtrl.getNewResultAnalyst)
);

adminResultRouter.get(
  "/analyst/progress",
  handleAsync(ResultCtrl.getUserProgressAnalyst)
);
export default adminResultRouter;
