import { recommendModel } from "../../models/recommend";
import { UserTargetScore } from "../../models/user.model";
export function getLastRecommend(userId: string) {
  return recommendModel.findOne({ userId }).sort({ createdAt: -1 });
}
export function createRecommend({
  userId,
  content,
  targetScore,
}: {
  userId: string;
  content: string;
  targetScore: UserTargetScore;
}) {
  return recommendModel.create({ userId, content, targetScore });
}
