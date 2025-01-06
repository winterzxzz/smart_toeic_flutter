import { CustomError } from "./custom_error";

export class NotFoundError extends CustomError {
  public statusCode: number = 404;
  public message: string;
  public serializeError(): { message: string; field?: string }[] {
    return [
      {
        message: this.message,
      },
    ];
  }
  constructor(message?: string) {
    super("Not found");
    this.message = "API endpoint not found";
    if (message) {
      this.message = message;
    }
    Object.setPrototypeOf(this, NotFoundError.prototype);
  }
}
