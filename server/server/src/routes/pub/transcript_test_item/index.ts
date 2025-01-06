//@ts-nocheck
import express, { Request, Response, NextFunction } from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import multer from "multer";
import fs from "fs";
import path from "path";
import { createTranscriptTestItem } from "../../../services/transcript_test_item";
import { transcriptTestModel } from "../../../models/transcript_test.model";
import TranscriptTestItemCtrl from "../../../controllers/transcript_test_item";
import { generateOTP } from "../../../utils";

const uploadsDir = path.join(__dirname, "../../../uploads");
const storage = multer.diskStorage({
  destination: async (req, file, cb) => {
    if (!req.body.transcriptTestId) {
      return cb(new Error("Transcript test ID is required"));
    }
    const transcript = await transcriptTestModel.findById(
      req.body.transcriptTestId
    );
    if (!transcript) {
      return cb(new Error("Transcript test not found"));
    }
    let uploadPath;
    uploadPath = path.join(uploadsDir, transcript.url, transcript.code);
    req.preUrl = "/" + transcript.url + "/" + transcript.code;
    fs.mkdirSync(uploadPath!, { recursive: true }); // Create directory structure
    cb(null, uploadPath!);
  },
  filename: (req, file, cb) => {
    const timeSecondRecommend = Date.now();
    const randomId = generateOTP();
    cb(null, timeSecondRecommend + "_" + randomId + "_" + file.originalname);
  },
});
const upload = multer({ storage });
const uploadFields = multer().fields([
  { name: "transcriptTestId", maxCount: 1 },
  { name: "transcript", maxCount: 1 },
]);

const pubTranscriptTestItemRouter = express.Router();
pubTranscriptTestItemRouter.get(
  "/",
  handleAsync(TranscriptTestItemCtrl.getByQuery)
);
pubTranscriptTestItemRouter.post(
  "/",

  upload.single("audio"),
  handleAsync(async (req, res) => {
    const data = {
      audioUrl: req.preUrl + "/" + req.file.filename,
      transcriptTestId: req.body.transcriptTestId,
      transcript: req.body.transcript,
    };
    const rs = await createTranscriptTestItem(data);
    res.status(200).json(rs);
  })
);
pubTranscriptTestItemRouter.get(
  "/transcript-test-id",
  handleAsync(TranscriptTestItemCtrl.getByTranscriptTestId)
);
export default pubTranscriptTestItemRouter;
