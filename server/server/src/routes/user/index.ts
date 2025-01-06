import express from "express";
import { UserType } from "../../configs/interface";
import userAuthRouter from "./auth";
import userFlashcardRouter from "./flashcard";
import { handleAsync } from "../../middlewares/handle_async";
import { requireAuth } from "../../middlewares/require_auth";
import userSetFlashcardRouter from "./set_flashcard";
import testRouter from "./test";
import userResultRouter from "./result";
import userResultItemRouter from "./result_item";
import userPaymentRouter from "./payment";
import aiChatRouter from "./aichat";
import learingSetRouter from "./learning_set";
import learingFlashcardRouter from "./learning_flashcard";
import userProfileRouter from "./profile";
import providerRouter from "./provider";
const routerU = express.Router();
routerU.use("/auth", userAuthRouter);
routerU.use("/flashcard", handleAsync(requireAuth), userFlashcardRouter);
routerU.use("/set-flashcard", handleAsync(requireAuth), userSetFlashcardRouter);
routerU.use("/result", handleAsync(requireAuth), userResultRouter);
routerU.use("/result-item", handleAsync(requireAuth), userResultItemRouter);
routerU.use("/test", testRouter);
routerU.use("/payment", handleAsync(requireAuth), userPaymentRouter);
routerU.use("/ai-chat", handleAsync(requireAuth), aiChatRouter);
routerU.use("/learning-set", handleAsync(requireAuth), learingSetRouter);
routerU.use(
  "/learning-flashcard",
  handleAsync(requireAuth),
  learingFlashcardRouter
);
routerU.use("/profile", handleAsync(requireAuth), userProfileRouter);
routerU.use("/provider", handleAsync(requireAuth), providerRouter);
export default routerU;
