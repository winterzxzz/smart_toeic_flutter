import express, { NextFunction, Request, Response } from "express";
import { passportA } from "../../../configs/passport";
import { handleAsync } from "../../../middlewares/handle_async";
import { BadRequestError } from "../../../errors/bad_request_error";
import { requireAuth } from "../../../middlewares/require_auth";
import { userCtrl } from "../../../controllers/user";
import { AdminCtrl } from "../../../controllers/admin";

const adminAuthRouter = express.Router();
adminAuthRouter.get("/login", (req, res) => {
  res.json("Test success");
});
adminAuthRouter.post(
  "/login",
  passportA.authenticate("local", {
    failureRedirect: "/api/admin/login/failed",
  }),
  function (req: Request, res: Response) {
    res.json(req.user);
  }
);

adminAuthRouter.get(
  "/login/failed",
  handleAsync(function (req: Request, res: Response) {
    throw new BadRequestError("Username or password is wrong");
  })
);

adminAuthRouter.get("/getinfor", function (req: Request, res: Response) {
  res.json(req.user);
});
adminAuthRouter.post("/signup", handleAsync(AdminCtrl.localRegister));

adminAuthRouter.get(
  "/current-user",
  handleAsync(requireAuth),
  handleAsync(AdminCtrl.getCurrentUser)
);
adminAuthRouter.post("/logout", handleAsync(AdminCtrl.logout));

export default adminAuthRouter;
