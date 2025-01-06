//@ts-nocheck
import { Request, Response } from "express";
import TestSrv from "../../services/test";
import { TestAttr } from "../../models/test.model";

namespace TestCtrl {
  export async function create(req: Request, res: Response) {
    const data = req.body as TestAttr;
    const rs = await TestSrv.create(data);
    res.status(200).json(rs);
  }
  export async function getAll(req: Request, res: Response) {
    //@ts-ignore
    const userId = req.user?.id;
    const rs = await TestSrv.getAll(userId);
    res.status(200).json(rs);
  }
  export async function getByQuery(req: Request, res: Response) {
    const query = req.query;
    //@ts-ignore
    const userId = req.user?.id;
    const rs = await TestSrv.getByQuery(query, userId);
    res.status(200).json(rs);
  }
  export async function getByCode(req: Request, res: Response) {
    const { code } = req.query;
    const rs = await TestSrv.getByCode(code);
    res.status(200).json(rs);
  }
  export async function getById(req: Request, res: Response) {
    const { id } = req.query;
    const rs = await TestSrv.getById(id);
    res.status(200).json(rs);
  }
  export async function updateAll(req: Request, res: Response) {
    const body = req.body;
    const rs = await TestSrv.updateAll(body);
    res.status(200).json(rs);
  }

  export async function handleExcel(req: Request, res: Response) {
    const { id } = req.query;
    const rs = await TestSrv.handleExcel(id);
    res.status(200).json(rs);
  }
}
export default TestCtrl;
