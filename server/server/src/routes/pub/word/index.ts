import express, { Request, Response } from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import WordCtl from "../../../controllers/word";

const wordRouter = express.Router();
wordRouter.get("/4-random", handleAsync(WordCtl.get4RandomWords));
wordRouter.post("/many", handleAsync(WordCtl.createMany));

export default wordRouter;
