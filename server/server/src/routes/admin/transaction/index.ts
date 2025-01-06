import express from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import TransactionCtrl from "../../../controllers/transaction";

const adminTransactionRouter = express.Router();
adminTransactionRouter.get(
  "/last-7-months",
  handleAsync(TransactionCtrl.getTransactionsLast7Months)
);
adminTransactionRouter.get(
  "/last-7-days",
  handleAsync(TransactionCtrl.getTransactionsLast7Days)
);
adminTransactionRouter.get(
  "/last-7-years",
  handleAsync(TransactionCtrl.getTransactionsLast7Years)
);
adminTransactionRouter.get(
  "/analyst/new",
  handleAsync(TransactionCtrl.getNewTransactionAnalyst)
);
adminTransactionRouter.get("/", handleAsync(TransactionCtrl.getTransactions));
adminTransactionRouter.get(
  "/analyst/progress",
  handleAsync(TransactionCtrl.getProgressTransaction)
);
adminTransactionRouter.get("/", handleAsync(TransactionCtrl.getTransactions));
export default adminTransactionRouter;
