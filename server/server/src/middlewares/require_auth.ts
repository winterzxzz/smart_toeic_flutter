import { NextFunction, Request, Response } from "express";
import { NotAuthorizedError } from "../errors/not_authorized_error";

export async function requireAuth(
  req: Request,
  res: Response,
  next: NextFunction
) {
  if (!req.user) {
    throw new NotAuthorizedError();
  }

  return next();
}
