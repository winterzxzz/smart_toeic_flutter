//@ts-nocheck
import express, { Request, Response } from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import multer from "multer";
import fs from "fs";
import path from "path";
import { generateOTP } from "../../../utils";
import { testModel } from "../../../models/test.model";
import TestSrv from "../../../services/test";
const uploadsDir = path.join(__dirname, "../../../uploads");
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const randomId = req.randomId;
    let uploadPath;
    if (file.fieldname === "images") {
      uploadPath = path.join(uploadsDir, "images", randomId); // Thư mục cho audio
    } else if (file.fieldname === "audioFiles") {
      uploadPath = path.join(uploadsDir, "audios", randomId); // Thư mục cho documents
    } else if (file.fieldname === "excelFile") {
      uploadPath = path.join(uploadsDir, "excels", randomId); // Thư mục cho documents
    }
    fs.mkdirSync(uploadPath!, { recursive: true }); // Create directory structure
    cb(null, uploadPath!);
  },
  filename: (req, file, cb) => {
    cb(null, path.basename(file.originalname));
  },
});
const upload = multer({ storage });

const uploadRouter = express.Router();
uploadRouter.post(
  "/",
  (req: Request, res: Response, next) => {
    req.randomId = generateOTP().toString(); // Tạo randomId mới
    next();
  },
  upload.fields([
    { name: "images" },
    { name: "audioFiles" },
    { name: "excelFile" },
  ]),
  handleAsync(async (req: Request, res: Response) => {
    let data = {
      title: req.body.title,
      type: req.body.type,
      path: req.files.excelFile[0].filename,
      code: req.randomId,
      numberOfParts: Number.parseInt(req.body.numberOfParts),
      numberOfQuestions: Number.parseInt(req.body.numberOfQuestions),
    };
    const test = await TestSrv.create(data);
    res.status(200).json(test);
  })
);

export default uploadRouter;
