import express, { Request, Response } from "express";

import { handleAsync } from "../../../middlewares/handle_async";
import LearningSetCtl from "../../../controllers/learning_set";

const learingSetRouter = express.Router();
learingSetRouter.post("/", handleAsync(LearningSetCtl.addSetToLearn));
learingSetRouter.delete("/", handleAsync(LearningSetCtl.removeSetFromLearn));
learingSetRouter.get("/user", handleAsync(LearningSetCtl.getLearningSetByUser));
learingSetRouter.get("/set", handleAsync(LearningSetCtl.getLearningSetBySetId));
learingSetRouter.get("/id", handleAsync(LearningSetCtl.getLearningSetById));
export default learingSetRouter;
