import { BlogAttr } from "../../models/blog.model";
import { userModel } from "../../models/user.model";
import { blogModel } from "../../models/blog.model";

export const createBlogSrv = async (blog: BlogAttr) => {
  const newBlog = await blogModel.create(blog);
  return newBlog;
};
export const getBlogByIdSrv = async (id: string) => {
  const blog = await blogModel.findById(id);
  return blog;
};
export const increaseViewBlogSrv = async (id: string) => {
  const blog = await blogModel.findByIdAndUpdate(id, { $inc: { view: 1 } });
  return blog;
};
export const getBlogSrv = async (
  {
    offset,
    limit,
  }: {
    offset: number;
    limit: number;
  },
  userId?: string
) => {
  let isGetAll = false;
  let query: any = {};
  if (userId) {
    const user = await userModel.findById(userId);
    if (user?.role === "admin") {
      isGetAll = true;
    }
  }
  if (isGetAll) {
    query = {};
  } else {
    query = { isPublished: true };
  }
  const blogs = await blogModel.find(query).skip(offset).limit(limit).sort({
    createdAt: -1,
  });
  return blogs;
};
export const updateBlogSrv = async (id: string, blog: BlogAttr) => {
  const updatedBlog = await blogModel.findByIdAndUpdate(id, blog);
  return updatedBlog;
};
export const searchBlogSrv = async (search: string, userId?: string) => {
  let isGetAll = false;
  if (userId) {
    const user = await userModel.findById(userId);
    if (user?.role === "admin") {
      isGetAll = true;
    }
  }
  let query: any = {};
  if (isGetAll) {
    query = {
      $text: { $search: search },
    };
  } else {
    query = {
      $text: { $search: search },
      isPublished: true,
    };
  }
  if (!search) {
    delete query.$text;
  }
  const blogs = await blogModel.find(query);
  return blogs;
};
export const deleteBlogSrv = async (id: string) => {
  const blog = await blogModel.findByIdAndDelete(id);
  return blog;
};
export const getRelatedBlogSrv = async (id: string, limit: number) => {
  const currentBlog = await blogModel.findById(id);
  if (!currentBlog) {
    return [];
  }
  limit = Number(limit) || 4;
  const allBlogs = await blogModel
    .find({
      _id: { $ne: id },
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
      id: blog._id,
      relevanceScore: score,
    };
  });

  // Sort by relevance score and get top posts
  const relatedBlogs = scoredBlogs
    .sort((a: any, b: any) => b.relevanceScore - a.relevanceScore)
    .slice(0, limit);
  return relatedBlogs;
};
