import { ResultItemAttr } from "../../models/result_item.model";

export function calculateAverageTimeByPart(data: ResultItemAttr[]) {
  const timeDataByPart: Record<
    string,
    { totalQuestions: number; totalTime: number }
  > = {};

  // Group data by part and sum time
  data.forEach((item) => {
    const part = item.part;
    if (!timeDataByPart[part]) {
      timeDataByPart[part] = { totalQuestions: 0, totalTime: 0 };
    }
    timeDataByPart[part].totalQuestions += 1;
    timeDataByPart[part].totalTime += item.timeSecond;
  });

  // Calculate average time for each part
  const averageTimeByPart: Record<string, string> = {};
  for (const part in timeDataByPart) {
    const { totalQuestions, totalTime } = timeDataByPart[part];
    averageTimeByPart[part] = (totalTime / totalQuestions).toFixed(2);
  }

  return averageTimeByPart;
}
