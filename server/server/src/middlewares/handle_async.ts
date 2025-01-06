import { NextFunction, Request, Response } from "express";

export function handleAsync(
  func: (req: Request, res: Response, next: NextFunction) => Promise<any>
) {
  return (req: Request, res: Response, next: NextFunction) => {
    func(req, res, next).catch((err: unknown) => {
      next(err);
    });
  };
}
