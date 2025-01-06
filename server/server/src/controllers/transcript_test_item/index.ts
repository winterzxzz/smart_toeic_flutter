import { createTranscriptTestItem } from "../../services/transcript_test_item";
import { getTranscriptTestItemByTranscriptTestId } from "../../services/transcript_test_item";
import { Request, Response } from "express";
namespace TranscriptTestItemCtrl {
  export async function getByQuery(req: Request, res: Response) {
    const { transcriptTestId, audioUrl, transcript } = req.body;
    const rs = await createTranscriptTestItem({
      transcriptTestId,
      audioUrl,
      transcript,
    });
    res.status(200).json(rs);
  }
  export async function getByTranscriptTestId(req: Request, res: Response) {
    const { transcriptTestId } = req.query as { transcriptTestId: string };
    const rs = await getTranscriptTestItemByTranscriptTestId(transcriptTestId);
    res.status(200).json(rs);
  }
}
export default TranscriptTestItemCtrl;
