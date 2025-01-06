import { ValidationError } from "express-validator";
import { CustomError } from "./custom_error";

export class RequestValidationError extends CustomError {
  statusCode: number = 400;
  constructor(public errors: ValidationError[]) {
    super("Invalid request data");
    Object.setPrototypeOf(this, RequestValidationError.prototype);
  }
  serializeError(): { message: string; field?: string }[] {
    const formatErrors = this.errors.map((_x) => {
      return {
        message: _x.msg,
      };
    });
    return formatErrors;
  }
}
