import express from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import TranscriptTestCtrl from "../../../controllers/transcript_test";

const pubTranscriptTestRouter = express.Router();
pubTranscriptTestRouter.get("/", handleAsync(TranscriptTestCtrl.getByQuery));
pubTranscriptTestRouter.post("/", handleAsync(TranscriptTestCtrl.create));
export default pubTranscriptTestRouter;
