import express, { Request, Response } from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import BlogCtrl from "../../../controllers/blog";
import multer from "multer";
import path from "path";
import { generateOTP } from "../../../utils";
import fs from "fs";
const adminBlogRouter = express.Router();
const uploadsDir = path.join(__dirname, "../../../uploads");
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    let uploadPath;
    if (file.fieldname === "image") {
      uploadPath = path.join(uploadsDir, "blog");
    }

    // Tạo thư mục nếu chưa tồn tại
    try {
      fs.mkdirSync(uploadPath!, { recursive: true });
      cb(null, uploadPath!);
    } catch (err) {
      cb(err as Error, "");
    }
  },
  filename: (req, file, cb) => {
    // Lưu tên tệp gốc, đảm bảo an toàn
    const randomId = generateOTP();

    cb(null, path.basename(randomId + file.originalname));
  },
});

const upload = multer({ storage });

adminBlogRouter.post("/", handleAsync(BlogCtrl.createBlog));
adminBlogRouter.get("/", handleAsync(BlogCtrl.getBlog));
adminBlogRouter.get("/:id", handleAsync(BlogCtrl.getBlogById));
adminBlogRouter.put("/:id", handleAsync(BlogCtrl.updateBlog));
adminBlogRouter.delete("/:id", handleAsync(BlogCtrl.deleteBlog));
adminBlogRouter.post(
  "/upload-image",
  upload.single("image"),
  handleAsync(async (req: Request, res: Response) => {
    const image = req.file;
    const imageSrc = `/uploads/blog/${image?.filename}`;
    return res.status(200).json({ imageSrc });
  })
);
export default adminBlogRouter;
