import { ResultItemAttr } from "../../models/result_item.model";

// Function to calculate part-wise accuracy
export function calculateAccuracyByPart(data: ResultItemAttr[]) {
  const groupedByPart: Record<string, { total: number; correct: number }> = {};

  // Group data by part
  data.forEach((item) => {
    const part = item.part;
    if (!part) return;
    if (!groupedByPart[part]) {
      groupedByPart[part] = { total: 0, correct: 0 };
    }
    groupedByPart[part].total += 1;
    if (item.useranswer === item.correctanswer) {
      groupedByPart[part].correct += 1;
    }
  });

  // Calculate accuracy for each part
  const accuracyByPart: Record<string, string> = {};
  for (const part in groupedByPart) {
    const { total, correct } = groupedByPart[part];
    accuracyByPart[part] = ((correct / total) * 100).toFixed(2);
  }

  return accuracyByPart;
}
