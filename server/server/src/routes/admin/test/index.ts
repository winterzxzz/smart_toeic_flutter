//@ts-nocheck
import express, { Request, Response } from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import multer from "multer";
import fs from "fs";
import path from "path";
import { generateOTP } from "../../../utils";
import TestSrv from "../../../services/test";

const uploadsDir = path.join(__dirname, "../../../uploads");

// Cấu hình lưu trữ tệp
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const randomId = req.randomId;
    let uploadPath;

    if (file.fieldname === "images") {
      uploadPath = path.join(uploadsDir, "images", randomId);
    } else if (file.fieldname === "audioFiles") {
      uploadPath = path.join(uploadsDir, "audios", randomId);
    } else if (file.fieldname === "excelFile") {
      uploadPath = path.join(uploadsDir, "excels", randomId);
    }

    // Tạo thư mục nếu chưa tồn tại
    try {
      fs.mkdirSync(uploadPath!, { recursive: true });
      cb(null, uploadPath!);
    } catch (err) {
      cb(err, "");
    }
  },
  filename: (req, file, cb) => {
    // Lưu tên tệp gốc, đảm bảo an toàn
    cb(null, path.basename(file.originalname));
  },
});

const upload = multer({ storage });

const adminTestRouter = express.Router();

adminTestRouter.post(
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
    // Kiểm tra và gán dữ liệu từ `req.body`
    let { title, type, parts, numberOfQuestions, isPublished, difficulty } =
      req.body;

    if (!title || !type || !parts || !numberOfQuestions) {
      return res.status(400).json({ message: "Missing required fields" });
    }
    parts = JSON.parse(parts);
    // Kiểm tra xem tệp có được tải lên hay không
    const files: any = req.files;
    if (!files || !files.excelFile || !files.excelFile[0]) {
      return res.status(400).json({ message: "Excel file is required" });
    }

    const data = {
      title: title,
      type: type,
      parts: parts,
      path: files.excelFile[0].filename, // Lưu đường dẫn tệp Excel
      code: req.randomId, // Mã randomId
      numberOfParts: parts.length,
      numberOfQuestions: Number.parseInt(numberOfQuestions),
      isPublished: isPublished,
      difficulty: difficulty,
    };

    try {
      const test = await TestSrv.create(data); // Lưu thông tin vào database
      res.status(200).json(test);
    } catch (err) {
      res.status(500).json({ message: "Error creating test", error: err });
    }
  })
);

export default adminTestRouter;
