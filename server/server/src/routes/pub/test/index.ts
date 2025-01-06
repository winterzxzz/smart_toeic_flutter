import express, { Request, Response } from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import TestCtrl from "../../../controllers/test";

const testRouter = express.Router();
testRouter.get("/", handleAsync(TestCtrl.getByQuery));
// testRouter.get("/handleTest", handleAsync(TestCtrl.handleTest));
testRouter.get("/handle-excel", handleAsync(TestCtrl.handleExcel));
testRouter.get("/code", handleAsync(TestCtrl.getByCode));
testRouter.get("/id", handleAsync(TestCtrl.getById));
testRouter.patch("/all", handleAsync(TestCtrl.updateAll));
// testRouter.get("/code", handleAsync(TestCtrl.getByCode));
// testRouter.get("/exam", handleAsync(TestCtrl.handleTest2));
export default testRouter;
