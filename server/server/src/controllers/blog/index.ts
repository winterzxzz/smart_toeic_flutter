import { Request, Response } from "express";
import {
  createBlogSrv,
  deleteBlogSrv,
  getBlogByIdSrv,
  getBlogSrv,
  getRelatedBlogSrv,
  increaseViewBlogSrv,
  searchBlogSrv,
  updateBlogSrv,
} from "../../services/blog";

namespace BlogCtrl {
  export const createBlog = async (req: Request, res: Response) => {
    const blog = await createBlogSrv(req.body);
    return res.status(200).json(blog);
  };
  export const getBlogById = async (req: Request, res: Response) => {
    const blog = await getBlogByIdSrv(req.params.id);
    return res.status(200).json(blog);
  };
  export const getBlog = async (req: Request, res: Response) => {
    const { offset, limit } = req.query as { offset: string; limit: string };
    const blogs = await getBlogSrv({
      offset: parseInt(offset),
      limit: parseInt(limit),
    });
    return res.status(200).json(blogs);
  };
  export const increaseViewBlog = async (req: Request, res: Response) => {
    const blog = await increaseViewBlogSrv(req.params.id);
    return res.status(200).json(blog);
  };
  export const updateBlog = async (req: Request, res: Response) => {
    const blog = await updateBlogSrv(req.params.id, req.body);
    return res.status(200).json(blog);
  };
  export const searchBlog = async (req: Request, res: Response) => {
    const { search } = req.query;
    const userId = req.user?.id;
    // @ts-ignore
    const blogs = await searchBlogSrv(search as string, userId);

    return res.status(200).json(blogs);
  };
  export const deleteBlog = async (req: Request, res: Response) => {
    const blog = await deleteBlogSrv(req.params.id);
    return res.status(200).json(blog);
  };
  export const getRelatedBlog = async (req: Request, res: Response) => {
    const id = req.params.id;
    const { limit } = req.query as { limit: string };
    const blogs = await getRelatedBlogSrv(id, Number(limit));
    return res.status(200).json(blogs);
  };
}
export default BlogCtrl;
