import express, { Request, Response } from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import TestCtrl from "../../../controllers/test";
import { requireAuth } from "../../../middlewares/require_auth";

const testRouter = express.Router();
testRouter.post("/", handleAsync(requireAuth), handleAsync(TestCtrl.create));
// testRouter.get("/", handleAsync(TestCtrl.getAll));
testRouter.get("/", handleAsync(TestCtrl.getByQuery));

export default testRouter;
