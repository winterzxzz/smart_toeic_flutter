export abstract class CustomError extends Error {
  abstract statusCode: number;
  abstract serializeError(): {
    message: string;
    field?: string;
  }[];
  constructor(public message: string) {
    // super();
    super(message);
    Object.setPrototypeOf(this, CustomError.prototype);
  }
}
