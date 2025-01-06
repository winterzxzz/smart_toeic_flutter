//@ts-nocheck
import express, { Request, Response } from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import multer from "multer";
import fs from "fs";
import path from "path";
import { generateOTP } from "../../../utils";
import ProfileCtrl from "../../../controllers/profile";
import { userCtrl } from "../../../controllers/user";
import { userSrv } from "../../../services/user";
const uploadsDir = path.join(__dirname, "../../../uploads/profile");
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const randomId = req.randomId;
    let uploadPath;
    if (file.fieldname === "avatar") {
      uploadPath = path.join(uploadsDir, "avatars");
    }
    if (!uploadPath) return cb(new Error("Upload path is required"));
    fs.mkdirSync(uploadPath!, { recursive: true }); // Create directory structure
    cb(null, uploadPath!);
  },
  filename: (req, file, cb) => {
    const fileExtension = path.extname(file.originalname); // Lấy phần mở rộng của file
    const randomFileName = `${req.randomId}_${Date.now()}${fileExtension}`; // Tạo tên ngẫu nhiên
    cb(null, randomFileName);
  },
});
const upload = multer({ storage });

const userProfileRouter = express.Router();
userProfileRouter.post(
  "/update-avatar",
  (req: Request, res: Response, next) => {
    req.randomId = generateOTP().toString(); // Tạo randomId mới
    next();
  },
  upload.fields([{ name: "avatar" }]),
  handleAsync(async (req: Request, res: Response) => {
    const user = req.user;
    const avatar = "/uploads/profile/avatars/" + req.files?.avatar[0].filename;
    const updatedUser = await userSrv.updateAvatar(user.id, avatar);
    res.status(200).json(avatar);
  })
);
userProfileRouter.post("/update-profile", handleAsync(userCtrl.updateProfile));
userProfileRouter.get("/analysis", handleAsync(ProfileCtrl.getAnalyst));
userProfileRouter.post(
  "/update-target-score",
  handleAsync(userCtrl.updateTargetScore)
);
userProfileRouter.get(
  "/recommend",
  handleAsync(ProfileCtrl.getSuggestForStudy)
);
export default userProfileRouter;
