import { NextFunction, Request, Response } from "express";
import { validationResult } from "express-validator";
import { RequestValidationError } from "../errors/request_validation_error";

export const validate_request = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  //a
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    throw new RequestValidationError(errors.array());
  }
  next();
};
