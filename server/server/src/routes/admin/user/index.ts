import express from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import { userCtrl } from "../../../controllers/user";

const adminUserRouter = express.Router();
adminUserRouter.get("/", handleAsync(userCtrl.getAllUsers));
adminUserRouter.get("/upgrade", handleAsync(userCtrl.getUpgradeUsers));
adminUserRouter.get("/analyst/new", handleAsync(userCtrl.getNewUserAnalyst));
adminUserRouter.get(
  "/analyst/upgrade",
  handleAsync(userCtrl.getUpgradeUserAnalyst)
);
adminUserRouter.get(
  "/analyst/progress",
  handleAsync(userCtrl.getUserProgressAnalyst)
);
export default adminUserRouter;
