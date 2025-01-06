import {
  TranscriptTestAttr,
  transcriptTestModel,
} from "../../models/transcript_test.model";
import { generateOTP } from "../../utils";
export async function getTranscriptTest() {
  const rs = await transcriptTestModel.find({});
  return rs;
}
export async function createTranscriptTest(data: {
  description: string;
  title: string;
}) {
  const code = generateOTP().toString();
  const url = "transcript-test";
  const rs = await transcriptTestModel.create({
    ...data,
    code,
    url,
  });
  return rs;
}
