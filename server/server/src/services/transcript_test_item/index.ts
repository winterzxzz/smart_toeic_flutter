import {
  TranscriptTestItemAttr,
  transcriptTestItemModel,
} from "../../models/transcript_test_item.model";

export async function createTranscriptTestItem(data: TranscriptTestItemAttr) {
  const rs = await transcriptTestItemModel.create(data);
  return rs;
}
export async function getTranscriptTestItemByTranscriptTestId(
  transcriptTestId: string
) {
  const rs = await transcriptTestItemModel.find({
    transcriptTestId,
  });
  return rs;
}
