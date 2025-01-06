import express, { Request, Response } from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import PaymentCtrl from "../../../controllers/payment";
const pubPaymentRouter = express.Router();
pubPaymentRouter.post("/callback", handleAsync(PaymentCtrl.callback));

export default pubPaymentRouter;
