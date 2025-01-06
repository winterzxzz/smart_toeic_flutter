import express from "express";

import testRouter from "./test";
import { handleAsync } from "../../middlewares/handle_async";
import pubPaymentRouter from "./payment";
import uploadRouter from "./upload_test";
import wordRouter from "./word";
import pubBlogRouter from "./blog";
import pubTranscriptTestRouter from "./transcript_test";
import pubTranscriptTestItemRouter from "./transcript_test_item";
const routerP = express.Router();
routerP.use("/test", testRouter);
routerP.use("/payment", pubPaymentRouter);
routerP.use("/upload", uploadRouter);
routerP.use("/word", wordRouter);
routerP.use("/blog", pubBlogRouter);
routerP.use("/transcript-test", pubTranscriptTestRouter);
routerP.use("/transcript-test-item", pubTranscriptTestItemRouter);
export default routerP;
