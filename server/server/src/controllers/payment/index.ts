import { Request, Response } from "express";
import PaymentSrv from "../../services/payment";
namespace PaymentCtrl {
  export async function create(req: Request, res: Response) {
    //@ts-ignore
    const userId = req.user.id;
    const rs = await PaymentSrv.create(userId);
    res.status(201).json(rs);
  }
  export async function getStatus(req: Request, res: Response) {
    const transId = req.query.transId as string;
    const rs = await PaymentSrv.getStatus(transId);
    res.status(200).json(rs);
  }
  export async function callback(req: Request, res: Response) {
    const rs = await PaymentSrv.callback(req.body);
    return rs;
  }
}
export default PaymentCtrl;
