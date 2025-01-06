import { validationResult } from "express-validator";
import { UserAttr, userModel } from "../../models/user.model";
import { Request, Response } from "express";
import { RequestValidationError } from "../../errors/request_validation_error";
import { NotAuthorizedError } from "../../errors/not_authorized_error";
import { userSrv } from "../../services/user";

async function login(req: Request, res: Response) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    throw new RequestValidationError(errors.array());
  }
  const { email, password } = req.body;
  const user = await userSrv.localLogin({ email, password });
  res.status(200).json(user);
}
async function getCurrentUser(req: Request, res: Response) {
  const user = req.user;
  if (!user) {
    throw new NotAuthorizedError();
  }
  res.status(200).json(user);
}
async function logout(req: Request, res: Response) {
  req.session = null;
  res.status(200).json({});
}
async function updateProfile(req: Request, res: Response) {
  // @ts-ignore
  const userId = req.user?.id!;
  const { name, bio } = req.body;
  const updatedUser = await userSrv.updateProfile(userId, {
    name,
    bio,
  });
  res.status(200).json(updatedUser);
}
async function updateTargetScore(req: Request, res: Response) {
  // @ts-ignore
  const userId = req.user?.id!;
  const { reading, listening } = req.body;
  const updatedUser = await userSrv.updateTargetScore(userId, {
    reading,
    listening,
  });
  res.status(200).json(updatedUser);
}
async function getAllUsers(req: Request, res: Response) {
  const users = await userSrv.getAllUsers();

  res.status(200).json(users);
}
async function getUpgradeUsers(req: Request, res: Response) {
  const users = await userSrv.getUpgradeUsers();
  res.status(200).json(users);
}

async function getNewUserAnalyst(req: Request, res: Response) {
  const { step, num } = req.query;
  const data = await userSrv.getNewUserAnalyst(Number(step), Number(num));
  res.status(200).json(data);
}
async function getUpgradeUserAnalyst(req: Request, res: Response) {
  const { step, num } = req.query;
  const data = await userSrv.getUpgradeUserAnalyst(Number(step), Number(num));
  res.status(200).json(data);
}
async function getUserProgressAnalyst(req: Request, res: Response) {
  const data = await userSrv.getUserProgressAnalyst();
  res.status(200).json(data);
}
export const userCtrl = {
  logout,
  getCurrentUser,
  updateProfile,
  updateTargetScore,
  getAllUsers,
  getUpgradeUsers,
  getNewUserAnalyst,
  getUpgradeUserAnalyst,
  getUserProgressAnalyst,
};
