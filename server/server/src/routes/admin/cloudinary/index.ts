import cloudinary from "../../../configs/cloudinary"; // Cấu hình cloudinary từ file configs
import { Router, Request, Response } from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import multer from "multer";

const adminCloudinaryRouter = Router();

// Sử dụng Multer để xử lý file upload
const storage = multer.memoryStorage();
const upload = multer({ storage });

// Endpoint upload hình ảnh lên Cloudinary
adminCloudinaryRouter.post(
  "/upload-image",
  upload.single("image"), // Đặt tên field là "image"
  handleAsync(async (req: Request, res: Response) => {
    if (!req.file) {
      return res.status(400).json({ error: "No file uploaded" });
    }

    // Đọc buffer của file upload
    const fileBuffer = req.file.buffer.toString("base64");
    const base64Image = `data:${req.file.mimetype};base64,${fileBuffer}`;

    try {
      // Upload hình ảnh lên Cloudinary
      const result = await cloudinary.uploader.upload(base64Image, {
        folder: "admin_images", // Đặt folder Cloudinary
        use_filename: false, // Dùng tên file
        unique_filename: true, // Không tạo tên file ngẫu nhiên
      });

      // Trả về kết quả
      return res.status(200).json({
        message: "Image uploaded successfully",
        url: result.secure_url,
        public_id: result.public_id,
      });
    } catch (error) {
      console.error("Upload to Cloudinary failed:", error);
      return res.status(500).json({ error: "Failed to upload image" });
    }
  })
);

export default adminCloudinaryRouter;
