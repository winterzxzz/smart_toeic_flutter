//@ts-nocheck
import express, { Request, Response } from "express";
import { userCtrl } from "../../../controllers/user";
import { handleAsync } from "../../../middlewares/handle_async";
import { requireAuth } from "../../../middlewares/require_auth";
import { BadRequestError } from "../../../errors/bad_request_error";
import { constEnv } from "../../../configs/const";
import { passportU } from "../../../configs/passport";
import { validate_request } from "../../../middlewares/validate_request";
import { body } from "express-validator";
import { redis, redisKey } from "../../../connect/redis";
import { delay, generateOTP } from "../../../utils";
import bcrypt from "bcrypt";

import {
  sendMailChangePW,
  sendMailVerifyEmail,
} from "../../../configs/nodemailer";
import { userModel } from "../../../models/user.model";

import mongoose from "mongoose";
import { hashPassword, userSrv } from "../../../services/user";

const userAuthRouter = express.Router();

userAuthRouter.get("/login", handleAsync(requireAuth), (req, res) => {
  res.json("Test success");
});
userAuthRouter.post(
  "/signup",
  [
    body("email").isEmail().withMessage("Email is required"),
    body("name").notEmpty().withMessage("Name is required"),
    body("password")
      .trim()
      .isLength({ min: 4, max: 50 })
      .withMessage("Password must be between 4 and 50 characters"),
  ],
  handleAsync(async function (req: Request, res: Response) {
    const { name, email, password } = req.body;
    const user = await userSrv.localCreate({ name, email, password });
    res.status(200).json(user);
  })
);
userAuthRouter.post(
  "/local-signup-cache",
  [
    body("email").isEmail().withMessage("Email is required"),
    body("name").notEmpty().withMessage("Name is required"),
    body("password")
      .trim()
      .isLength({ min: 4, max: 50 })
      .withMessage("Password must be between 4 and 50 characters"),
  ],
  handleAsync(async function (req: Request, res: Response) {
    const { name, email, password } = req.body;
    const userEx = await userModel.findOne({ email });
    if (userEx) {
      throw new BadRequestError("Email in use");
    }
    // const user = await userSrv.localCreate({ name, email, password });
    // res.status(200).json(user);
    const storeStr = JSON.stringify({ name, email, password });
    const key = new mongoose.Types.ObjectId().toString();
    await redis.client.set(key, storeStr, {
      EX: 60 * 60,
    });
    res.status(200).json({ key });
  })
);
userAuthRouter.post(
  "/login",
  [
    body("email").isEmail().withMessage("Email must be valid"),
    body("password").trim().notEmpty().withMessage("Password is required"),
  ],
  handleAsync(validate_request),
  passportU.authenticate("local", {
    failureRedirect: "/failed",
  }),
  function (req: Request, res: Response) {
    res.json(req.user);
  }
);

userAuthRouter.get("/google-login", passportU.authenticate("google"));

userAuthRouter.get(
  "/google-login/callback",
  passportU.authenticate("google"),
  function (req: Request, res: Response) {
    res.redirect(constEnv.clientOrigin!);
  }
);
userAuthRouter.get("/facebook-login", passportU.authenticate("facebook"));
userAuthRouter.get(
  "/facebook-login/callback",
  passportU.authenticate("facebook"),
  function (req: Request, res: Response) {
    res.redirect(constEnv.clientOrigin!);
  }
);
userAuthRouter.post(
  "/login/failed",
  handleAsync(function (req: Request, res: Response) {
    throw new BadRequestError("Username or password is wrong");
  })
);
userAuthRouter.get(
  "/getinfor",
  handleAsync(requireAuth),
  handleAsync(async (req: Request, res: Response) => {
    const user = await userSrv.getById(req.user.id);
    res.json(user);
  })
);
userAuthRouter.post("/logout", function (req: Request, res: Response) {
  req.session = null;
  res.json("1");
});

userAuthRouter.get(
  "/current-user",
  handleAsync(requireAuth),
  handleAsync(userCtrl.getCurrentUser)
);
userAuthRouter.post("/logout", handleAsync(userCtrl.logout));
userAuthRouter.post(
  "/otp/reset-password",
  [body("email").isEmail().withMessage("Email is not provided or valid!")],
  handleAsync(validate_request),
  handleAsync(async (req: Request, res: Response) => {
    const otp = generateOTP();
    const { email } = req.body;
    const storeStr = JSON.stringify({ otp, email });
    await redis.client.del(redisKey.resetPwOTPKey(email));
    const set = await redis.client.set(
      redisKey.resetPwOTPKey(email),
      storeStr,
      {
        EX: 5 * 60,
      }
    );

    await sendMailChangePW({ otp: otp, to: email });
    res.status(200).json({
      status: 1,
      message: "OTP sent to email",
    });
  })
);





userAuthRouter.post(
  "/request/reset-password",
  [
    body("password").trim().notEmpty().withMessage("Password is required"),
    body("otp").trim().notEmpty().withMessage("OTP is required"),
  ],
  handleAsync(async (req: Request, res: Response) => {
    const { password, otp, email } = req.body;

    const storeStr = await redis.client.get(redisKey.resetPwOTPKey(email));
    if (!storeStr) {
      throw new BadRequestError("OTP or email is not valid");
    }
    const store = JSON.parse(storeStr);

    if (store?.email !== email || store?.otp !== otp) {
      throw new BadRequestError("OTP or email is not valid");
    }
    const user = await userModel.findOne({
      email: email,
    });
    if (!user) {
      throw new BadRequestError("Email is not valid");
    }
    const hashPassword = await bcrypt.hash(
      password,
      parseInt(constEnv.passwordSalt!)
    );
    user.set({
      password: hashPassword,
    });
    await user.save();
    redis.client.del(redisKey.resetPwOTPKey(email));
    res.status(200).json(1);
  })
);

userAuthRouter.post(
  "/otp/verify-email",
  [
    body("key").notEmpty().withMessage("Key is required"),
    body("email").isEmail().withMessage("Email is required"),
  ],

  handleAsync(validate_request),
  handleAsync(async (req: Request, res: Response) => {
    const { key, email } = req.body;
    const storeStr = await redis.client.get(key);
    if (!storeStr) {
      throw new BadRequestError("Some thing wrong with key.");
    }
    const store = JSON.parse(storeStr);
    const otp = generateOTP();
    store.otp = otp;
    redis.client.del(redisKey.verifyEmailKey(email));
    const set = await redis.client.set(
      redisKey.verifyEmailKey(email),
      JSON.stringify(store),
      {
        EX: 5 * 60,
      }
    );
    await sendMailVerifyEmail({ otp: otp, to: email });
    res.status(200).json({
      status: 1,
      message: "OTP sent to email",
    });
  })
);
userAuthRouter.post(
  "/request/verify-email",
  [
    body("otp").notEmpty().withMessage("OTP is required"),
    body("email").isEmail().withMessage("Email is required"),
  ],

  handleAsync(validate_request),
  handleAsync(async (req: Request, res: Response) => {
    const { email, otp } = req.body;
    const storeStr = await redis.client.get(redisKey.verifyEmailKey(email));
    if (!storeStr) {
      throw new BadRequestError("Email is not valid");
    }
    const store = JSON.parse(storeStr);
    if (store.otp !== otp) {
      throw new BadRequestError("OTP is not valid");
    }
    if (store.password) {
      store.password = await hashPassword(store.password);
    }
    const user = await userModel.create(store);
    redis.client.del(redisKey.verifyEmailKey(email));
    await new Promise((resolve, reject) => {
      req.login(user, (err) => {
        if (err) {
          return reject(err); // Reject if login fails
        }
        resolve(1); // Resolve if login is successful
      });
    });
    res.status(200).json(user);
  })
);
export default userAuthRouter;
