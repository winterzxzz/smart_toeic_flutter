import { resultItemModel } from "../../models/result_item.model";
import { getTimeLastNDays } from "../../utils";
import { calculateAverageTimeByPart } from "../../utils/analyst/average_time";
import { calculateCategoryAccuracy } from "../../utils/analyst/category_accuracy";
import { calculateAccuracyByPart } from "../../utils/analyst/part_accuracy";
import { getScoreByAccuracy } from "../../utils/analyst/score";
import { timeSecondRecommend } from "../../const/toeic";
import { getLastRecommend } from "../recommend";
namespace ProfileService {
  export const getAnalyst = async (userId: string) => {
    const rs = await resultItemModel
      .find({
        userId: userId,
      })
      .lean();
    const accuracyByPart = calculateAccuracyByPart(rs);
    const averageTimeByPart = calculateAverageTimeByPart(rs);
    const categoryAccuracy = calculateCategoryAccuracy(rs);
    const { listenScore, readScore, score } =
      getScoreByAccuracy(accuracyByPart);
    return {
      accuracyByPart,
      averageTimeByPart,
      categoryAccuracy,
      listenScore,
      readScore,
      score,
      timeSecondRecommend,
    };
  };
  export const getSuggestForStudy = async (userId: string) => {
    const lastRecommend = await getLastRecommend(userId);
    return lastRecommend;
  };
}
export default ProfileService;
