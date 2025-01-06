import express, { Request, Response } from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import Resuk from "../../../controllers/result";
import ResultItemCtrl from "../../../controllers/result_item";
const userResultItemRouter = express.Router();
userResultItemRouter.get("/part", handleAsync(ResultItemCtrl.getByPart));
userResultItemRouter.get("/user", handleAsync(ResultItemCtrl.getByUser));
userResultItemRouter.get("/result", handleAsync(ResultItemCtrl.getByResult));

export default userResultItemRouter;
