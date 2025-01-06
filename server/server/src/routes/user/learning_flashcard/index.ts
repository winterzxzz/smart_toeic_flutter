import express, { Request, Response } from "express";

import { handleAsync } from "../../../middlewares/handle_async";
import LearningFlashcardCtl from "../../../controllers/learning_flashcard";

const learningFlashcardRouter = express.Router();
learningFlashcardRouter.get(
  "/set",
  handleAsync(LearningFlashcardCtl.getByLearningSet)
);
learningFlashcardRouter.post(
  "/update-short-term-score",
  handleAsync(LearningFlashcardCtl.updateShortTermScore)
);
learningFlashcardRouter.post("/update-session-score",handleAsync(LearningFlashcardCtl.updateSessionScore))
export default learningFlashcardRouter;
