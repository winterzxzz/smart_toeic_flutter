import express, { Request, Response } from "express";
import SetFlashcardCtrl from "../../../controllers/set_flashcard";
import { handleAsync } from "../../../middlewares/handle_async";

const userSetFlashcardRouter = express.Router();

userSetFlashcardRouter.post("/", handleAsync(SetFlashcardCtrl.create));
userSetFlashcardRouter.get("/id", handleAsync(SetFlashcardCtrl.getById));
userSetFlashcardRouter.get("/user", handleAsync(SetFlashcardCtrl.getByUser));
userSetFlashcardRouter.get("/public", handleAsync(SetFlashcardCtrl.getPublic));
userSetFlashcardRouter.delete("/", handleAsync(SetFlashcardCtrl.remove));
userSetFlashcardRouter.patch("/", handleAsync(SetFlashcardCtrl.update));
export default userSetFlashcardRouter;
