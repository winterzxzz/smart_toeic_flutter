import express, { Request, Response } from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import BlogCtrl from "../../../controllers/blog";
const pubBlogRouter = express.Router();
pubBlogRouter.get("/", handleAsync(BlogCtrl.getBlog));
pubBlogRouter.get("/search", handleAsync(BlogCtrl.searchBlog));

pubBlogRouter.get("/:id", handleAsync(BlogCtrl.getBlogById));
pubBlogRouter.post("/:id/view", handleAsync(BlogCtrl.increaseViewBlog));
pubBlogRouter.get("/:id/related", handleAsync(BlogCtrl.getRelatedBlog));
export default pubBlogRouter;
