import express, { Request, Response } from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import multer from "multer";
import { client } from "../../../configs/speechclient";
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });
const providerRouter = express.Router();
providerRouter.post(
  "/speech-to-text",
  upload.single("audio"),
  handleAsync(async (req: Request, res: Response) => {
    console.log(req.file);

    if (!req.file) {
      return res.status(400).send("No file uploaded");
    }
    if (req.file.mimetype !== "audio/webm") {
      return res
        .status(400)
        .send("Invalid file format. Only WAV is supported.");
    }
    const audioBytes = req.file.buffer.toString("base64");
    const audio = { content: audioBytes };

    const config = {
      encoding: "WEBM_OPUS", // Định dạng WebM Opus
      sampleRateHertz: 48000, // WebM thường sử dụng sample rate 48kHz
      languageCode: "en-US", // Ngôn ngữ sử dụng
    };

    const request = {
      audio: audio,
      config: config,
    };

    try {
      // Gọi API Google Cloud Speech-to-Text
      const [response] = await client.recognize(request);
      const transcript = response.results
        .map((result: any) => result.alternatives[0].transcript)
        .join("\n");
      console.log(transcript);
      res.json({ transcript });
    } catch (error) {
      console.error("Error:", error);
      res
        .status(500)
        .send("An error occurred while processing the speech-to-text request");
    }
  })
);

export default providerRouter;
