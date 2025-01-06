import { Router } from "express";
import { Request, Response } from "express";
import { handleAsync } from "../../../middlewares/handle_async";
import { blogModel } from "../../../models/blog.model";
import _ from "lodash";
const blogRouter = Router();

blogRouter.get(
  "/related/:blogId",
  handleAsync(async (req: Request, res: Response) => {
    const { blogId } = req.params;
    const limit = Number(req.query.limit) || 4; // Default to 4 related posts

    // First, get the current blog to find its category
    const currentBlog = await blogModel.findById(blogId);
    if (!currentBlog) {
      return res.status(404).json({
        success: false,
        message: "Blog not found",
      });
    }

    // Find related blogs:
    // 1. Same category
    // 2. Exclude current blog
    // 3. Only published blogs
    // 4. Sort by date (newest first)
    const relatedBlogs = await blogModel
      .find({
        _id: { $ne: blogId }, // Exclude current blog
        category: currentBlog.category,
        isPublished: true,
      })
      .sort({ createdAt: -1 })
      .limit(limit)
      .select({
        title: 1,
        description: 1,
        image: 1,
        category: 1,
        author: 1,
        createdAt: 1,
        view: 1,
      });

    // If we don't have enough related posts in the same category,
    // we can fetch additional posts from other categories
    if (relatedBlogs.length < limit) {
      const remainingCount = limit - relatedBlogs.length;
      const additionalBlogs = await blogModel
        .find({
          _id: { $ne: blogId },
          category: { $ne: currentBlog.category },
          isPublished: true,
        })
        .sort({ createdAt: -1 })
        .limit(remainingCount)
        .select({
          title: 1,
          description: 1,
          image: 1,
          category: 1,
          author: 1,
          createdAt: 1,
          view: 1,
        });

      relatedBlogs.push(...additionalBlogs);
    }

    res.status(200).json({
      success: true,
      data: relatedBlogs,
      message: "Related blogs fetched successfully",
    });
  })
);

// Alternative API with more sophisticated relevance scoring
blogRouter.get(
  "/related-advanced/:blogId",
  handleAsync(async (req: Request, res: Response) => {
    const { blogId } = req.params;
    const limit = Number(req.query.limit) || 4;

    const currentBlog = await blogModel.findById(blogId);
    if (!currentBlog) {
      return res.status(404).json({
        success: false,
        message: "Blog not found",
      });
    }

    // Get all published blogs except current one
    const allBlogs = await blogModel
      .find({
        _id: { $ne: blogId },
        isPublished: true,
      })
      .select({
        title: 1,
        description: 1,
        image: 1,
        category: 1,
        author: 1,
        createdAt: 1,
        view: 1,
      });

    // Calculate relevance score for each blog
    const scoredBlogs = allBlogs.map((blog: any) => {
      let score = 0;

      // Same category: +3 points
      if (blog.category === currentBlog.category) {
        score += 3;
      }

      // Same author: +2 points
      if (blog.author === currentBlog.author) {
        score += 2;
      }

      // Popular posts (more views): +1 point
      if (blog.view > 100) {
        score += 1;
      }

      // Newer posts get a small boost
      const daysSinceCreation = Math.floor(
        (Date.now() - blog.createdAt.getTime()) / (1000 * 60 * 60 * 24)
      );
      if (daysSinceCreation < 30) {
        score += 0.5;
      }

      return {
        ...blog.toObject(),
        relevanceScore: score,
      };
    });

    // Sort by relevance score and get top posts
    const relatedBlogs = scoredBlogs
      .sort((a: any, b: any) => b.relevanceScore - a.relevanceScore)
      .slice(0, limit);

    res.status(200).json({
      success: true,
      data: relatedBlogs,
      message: "Related blogs fetched successfully",
    });
  })
);

export default blogRouter;
