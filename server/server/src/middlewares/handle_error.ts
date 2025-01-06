import { NextFunction, Request, Response } from "express";
import { error } from "console";
import { CustomError } from "../errors/custom_error";

function handleError(
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
) {
  if (err instanceof CustomError) {
    return res.status(err.statusCode).json({ errors: err.serializeError() });
  }

  console.error(err);
  console.log(err.message);
  return res.status(400).json({
    errors: [{ message: err.message }],
  });
}
export { handleError };
