import { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import { constEnv } from "../configs/const";
interface UserPayload {
  id: string;
  email: string;
}
declare global {
  namespace Express {
    interface Request {
      user?: UserPayload;
    }
  }
}
export async function verifyUser(
  req: Request,
  res: Response,
  next: NextFunction
) {
  if (!req.session?.jwt) {
    return next();
  }
  const user = jwt.verify(req.session.jwt, constEnv.jwtSecret!) as UserPayload;
  req.user = user;
  return next();
}
