import { CustomError } from "./custom_error";

export class NotAuthorizedError extends CustomError {
  public statusCode: number = 401;
  constructor() {
    super("Not authorized");
    Object.setPrototypeOf(this, NotAuthorizedError.prototype);
  }
  serializeError(): { message: string; field?: string }[] {
    return [
      {
        message: "Not authorized",
      },
    ];
  }
}
