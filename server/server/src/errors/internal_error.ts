import { CustomError } from "./custom_error";

export class InternalError extends CustomError {
  public statusCode: number = 500;
  constructor(message: string = "Something wrong in server") {
    super(message);
    Object.setPrototypeOf(this, InternalError.prototype);
  }
  public serializeError(): { message: string; field?: string }[] {
    return [{ message: this.message }];
  }
}
