import {
  createTranscriptTest,
  getTranscriptTest,
} from "../../services/transcript_test";
import { Request, Response } from "express";
namespace TranscriptTestCtrl {
  export async function getByQuery(req: Request, res: Response) {
    const rs = await getTranscriptTest();
    res.status(200).json(rs);
  }
  export async function create(req: Request, res: Response) {
    const { description, title } = req.body;
    const rs = await createTranscriptTest({
      description,
      title,
    });
    res.status(200).json(rs);
  }
}

export default TranscriptTestCtrl;
