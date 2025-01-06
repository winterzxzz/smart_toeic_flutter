import { CustomError } from "./custom_error";

export class BadRequestError extends CustomError {
  statusCode: number = 400;
  constructor(message: string) {
    super(message);
    Object.setPrototypeOf(this, BadRequestError.prototype);
  }
  serializeError(): { message: string; field?: string }[] {
    return [
      {
        message: this.message,
      },
    ];
  }
}
