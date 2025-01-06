import { ToeicQuestionCategories } from "../../configs/questionCategory";
import { ResultItemAttr } from "../../models/result_item.model";

export function calculateCategoryAccuracy(questions: ResultItemAttr[]) {
  // Filter out questions without categories or empty categories
  const validQuestions = questions.filter(
    (q) => q.questionCategory && q.questionCategory.length > 0
  );

  // Initialize statistics for each category
  const categoryStats: Record<string, { correct: number; total: number }> = {};

  // Loop through each question and count correct/total
  validQuestions.forEach((question) => {
    question.questionCategory.forEach((category) => {
      if (
        !ToeicQuestionCategories[
          category as keyof typeof ToeicQuestionCategories
        ]
      )
        return;
      if (!categoryStats[category]) {
        categoryStats[category] = { correct: 0, total: 0 };
      }
      // Increment total questions for the category
      categoryStats[category].total++;

      // Increment correct count if useranswer matches correctanswer
      if (question.useranswer === question.correctanswer) {
        categoryStats[category].correct++;
      }
    });
  });

  // Calculate accuracy for each category
  const categoryAccuracy: Record<
    string,
    { part: number; title: string; accuracy: string }
  > = {};
  Object.keys(categoryStats).forEach((category) => {
    categoryAccuracy[category] = {
      part: 0,
      title: "",
      accuracy: "",
    };
    const { correct, total } = categoryStats[category];
    if (
      !ToeicQuestionCategories[category as keyof typeof ToeicQuestionCategories]
    )
      return;
    // @ts-ignore
    categoryAccuracy[category].part = ToeicQuestionCategories[category].part;
    // @ts-ignore
    categoryAccuracy[category].title =
      //@ts-ignore
      ToeicQuestionCategories[category].vietnameseTitle;
    categoryAccuracy[category].accuracy = ((correct / total) * 100).toFixed(2);
  });

  return categoryAccuracy;
}
