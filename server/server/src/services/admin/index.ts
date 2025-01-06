import { userModel } from "../../models/user.model";
import bcrypt from "bcrypt";
import * as _ from "lodash";
import jwt from "jsonwebtoken";
import { constEnv } from "../../configs/const";
import { BadRequestError } from "../../errors/bad_request_error";
export async function adminLocalCreate(data: {
  email: string;
  password: string;
  name: string;
  role?: string;
}) {
  const checkEmail = await userModel.findOne({
    email: data.email,
    role: "admin",
  });

  if (checkEmail) {
    throw new BadRequestError("Email in use");
  }
  data.password = await bcrypt.hash(
    data.password,
    parseInt(constEnv.passwordSalt!)
  );
  data.role = "admin";
  // Store hash in your password DB.
  const user = await userModel.create(data);

  return user;
}
export async function adminLocalLogin(data: {
  email: string;
  password: string;
}) {
  const user = await userModel.findOne({
    email: data.email,
    role: "admin",
  });
  if (!user) {
    throw new BadRequestError("Email or password is wrong");
  }
  const verify = await bcrypt.compare(data.password, user.password as string);

  if (!verify) {
    throw new BadRequestError("Email or password is wrong");
  }

  return user;
}
export async function adminGetById(id: string) {
  const user = await userModel.findById(id).select("-password");
  return user;
}
