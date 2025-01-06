import { CustomError } from "./custom_error";

export class DatabaseConnectionError extends CustomError {
  public statusCode: number = 500;
  public reason = "Error connecting to databasse";
  constructor() {
    super("Connecting error");
    Object.setPrototypeOf(this, DatabaseConnectionError.prototype);
  }
  public serializeError(): { message: string; field?: string }[] {
    return [{ message: this.reason }];
  }
}
