import { GoogleGenerativeAI, SchemaType } from "@google/generative-ai";
import { genAI } from "./instance";
import { UserTargetScore } from "../../models/user.model";
const schema = {
  description:
    "Generate TOEIC improvement suggestions based on test performance data.",
  type: SchemaType.OBJECT,
  properties: {
    metadata: {
      type: SchemaType.OBJECT,
      properties: {
        testDate: {
          type: SchemaType.STRING,
          description: "Date of the TOEIC test (e.g., YYYY-MM-DD).",
        },
        currentScores: {
          type: SchemaType.OBJECT,
          properties: {
            listening: {
              type: SchemaType.INTEGER,
              description: "Listening score.",
            },
            reading: {
              type: SchemaType.INTEGER,
              description: "Reading score.",
            },
          },
          description: "Current scores for listening and reading.",
        },
        targetScores: {
          type: SchemaType.OBJECT,
          properties: {
            listening: {
              type: SchemaType.INTEGER,
              description: "Target listening score.",
            },
            reading: {
              type: SchemaType.INTEGER,
              description: "Target reading score.",
            },
          },
          description: "Target scores for improvement.",
        },
      },
      required: ["testDate", "currentScores", "targetScores"],
    },
    accuracyImprovement: {
      type: SchemaType.OBJECT,
      properties: {
        lowAccuracyParts: {
          type: SchemaType.ARRAY,
          items: {
            type: SchemaType.STRING,
            description: "Part numbers with low accuracy.",
          },
          description: "List of parts with low accuracy.",
        },
        focusAreas: {
          type: SchemaType.ARRAY,
          items: {
            type: SchemaType.STRING,
            description: "Categories of questions with low accuracy.",
          },
          description: "List of question categories requiring more practice.",
        },
      },
      required: ["lowAccuracyParts", "focusAreas"],
    },
    timeManagement: {
      type: SchemaType.OBJECT,
      properties: {
        partTimeRecommendations: {
          type: SchemaType.OBJECT,
          properties: {
            "1": {
              type: SchemaType.INTEGER,
              description: "Recommended time for Part 1.",
            },
            "2": {
              type: SchemaType.INTEGER,
              description: "Recommended time for Part 2.",
            },
            "3": {
              type: SchemaType.INTEGER,
              description: "Recommended time for Part 3.",
            },
            "4": {
              type: SchemaType.INTEGER,
              description: "Recommended time for Part 4.",
            },
            "5": {
              type: SchemaType.INTEGER,
              description: "Recommended time for Part 5.",
            },
            "6": {
              type: SchemaType.INTEGER,
              description: "Recommended time for Part 6.",
            },
            "7": {
              type: SchemaType.INTEGER,
              description: "Recommended time for Part 7.",
            },
          },
          description: "Recommended time allocation for each part.",
        },
      },
      required: ["partTimeRecommendations"],
    },
    skillImprovement: {
      type: SchemaType.OBJECT,
      properties: {
        listening: {
          type: SchemaType.STRING,
          description: "Suggestions for improving listening skills.",
        },
        reading: {
          type: SchemaType.STRING,
          description: "Suggestions for improving reading skills.",
        },
      },
      required: ["listening", "reading"],
    },
    overallStrategy: {
      type: SchemaType.OBJECT,
      properties: {
        strategySuggestions: {
          type: SchemaType.ARRAY,
          items: {
            type: SchemaType.STRING,
            description: "Overall strategies to improve TOEIC score.",
          },
          description: "Suggestions for overall test-taking strategies.",
        },
      },
      required: ["strategySuggestions"],
    },
  },
  required: [
    "metadata",
    "accuracyImprovement",
    "timeManagement",
    "skillImprovement",
    "overallStrategy",
  ],
};

export const recommendPrompt = (data: any, targetScore: UserTargetScore) => {
  const dataString = JSON.stringify(data);
  let notHaveTargetScore = `
Hãy phân tích dữ liệu này và đưa ra một kế hoạch học tập chi tiết để cải thiện điểm số TOEIC, tập trung vào các điểm yếu của tôi. Kế hoạch này cần bao gồm:

Phân tích chi tiết từng phần thi:
Chỉ ra những điểm mạnh, điểm yếu cụ thể trong từng phần và giải thích nguyên nhân. Đối với các phần nghe (Part 1, 2, 3, 4), không cần đề cập tới thời gian. Phân tích dựa trên hiệu suất hiện tại, chỉ ra các phần cần ưu tiên cải thiện.

Đề xuất cụ thể cho từng loại câu hỏi:
Đưa ra các ví dụ cụ thể về các loại câu hỏi tôi cần tập trung luyện tập, giải thích lý do và đề xuất cách tiếp cận hiệu quả.

Kế hoạch học tập chi tiết:
Lập một kế hoạch học tập cụ thể cho từng tuần, bao gồm:

- Các tài liệu học tập gợi ý.
- Thời gian dành cho từng phần (Listening và Reading).
- Các phương pháp học tập hiệu quả giúp cải thiện điểm theo từng phần.

Chiến lược tổng thể:
Đưa ra những lời khuyên chung về cách tiếp cận việc học TOEIC, ví dụ như cách quản lý thời gian, làm thế nào để duy trì động lực, và các mẹo làm bài thi.

Dữ liệu này là kết quả bài thi TOEIC của tôi, bao gồm các thông tin chi tiết về hiệu suất thi, thời gian làm bài và các chỉ số gợi ý cải thiện.

`;
  let haveTargetScore = `
Dữ liệu bài thi TOEIC của tôi bao gồm:
•	Điểm số tổng và từng phần: Phản ánh khả năng hiện tại trong Listening và Reading.
•	Độ chính xác từng Part (1-7): Tỷ lệ phần trăm câu trả lời đúng trong từng phần, giúp xác định các điểm mạnh và điểm yếu cụ thể.
•	Thời gian làm bài từng câu (chỉ với Part 5, 6, 7):
o	Thời gian trung bình: Tính bằng giây, cho biết bạn mất bao lâu để hoàn thành một câu hỏi trong phần Reading.
o	Thời gian tối ưu (recommended time): Cũng tính bằng giây, là khoảng thời gian được khuyến nghị để làm mỗi câu hỏi một cách hiệu quả, thường dựa trên tiêu chuẩn làm bài TOEIC.
•	Mục tiêu điểm số: Giúp xác định khoảng cách giữa điểm hiện tại và điểm mong muốn trong từng phần (Listening và Reading).
Đây là dữ liệu phân tích từ các bài thi của tôi
	${dataString}
Ý nghĩa của dữ liệu:
•	Độ chính xác: Cho thấy mức độ làm đúng câu hỏi và khả năng hiểu nội dung của từng Part.
•	Thời gian làm bài: Nếu thời gian trung bình cao hơn thời gian tối ưu, điều này có thể ảnh hưởng tiêu cực đến khả năng hoàn thành bài thi đúng giờ.
•	Mục tiêu điểm số: Dùng để định hướng kế hoạch cải thiện theo mức độ ưu tiên.
________________________________________
1. Phân tích chi tiết từng phần thi
Listening (Part 1-4):
•	Tập trung vào độ chính xác:
o	Part 1 (Hình ảnh): Đánh giá khả năng mô tả hình ảnh chính xác.
o	Part 2 (Hỏi đáp): Xác định khó khăn khi nghe hiểu câu hỏi và chọn đáp án phù hợp.
o	Part 3-4 (Hội thoại và bài nói): Tập trung vào khả năng nghe hiểu ý chính và các chi tiết cụ thể.
•	Nhấn mạnh các điểm yếu: Ví dụ, nếu Part 3 có độ chính xác thấp, có thể bạn gặp khó khăn trong việc xác định từ khóa hoặc theo dõi nhiều người nói.
Reading (Part 5, 6, 7):
•	Phân tích độ chính xác:
o	Part 5 (Ngữ pháp và từ vựng): Đánh giá lỗi sai phổ biến (ngữ pháp cơ bản hay từ vựng nâng cao).
o	Part 6 (Hoàn thành đoạn văn): Xác định khả năng hiểu ngữ cảnh để chọn đáp án phù hợp.
o	Part 7 (Đọc hiểu): Tập trung vào độ chính xác khi trả lời câu hỏi suy luận và câu hỏi chi tiết.
•	Phân tích thời gian làm bài:
o	So sánh thời gian trung bình với thời gian tối ưu để xác định liệu bạn có làm bài quá chậm hay không.
o	Ví dụ: Nếu thời gian trung bình cho Part 7 là 90 giây/câu, nhưng thời gian tối ưu là 75 giây/câu, bạn cần cải thiện tốc độ đọc hiểu mà vẫn giữ độ chính xác.
________________________________________
2. Đánh giá dựa trên mục tiêu
•	Mục tiêu điểm số:
o	Listening: ${targetScore.listening} điểm.
o	Reading: ${targetScore.reading} điểm.
•	Phân tích khoảng cách:
o	Nếu điểm hiện tại chênh lệch lớn so với mục tiêu, hãy xác định những kỹ năng cần cải thiện ngay.
o	Nếu chênh lệch nhỏ, đưa ra cách tối ưu hóa hiệu suất.
________________________________________
3. Đề xuất cụ thể cho từng loại câu hỏi
•	Part 5 (Ngữ pháp): Luyện các câu hỏi có tỷ lệ sai cao, ví dụ: thì động từ, câu bị động, liên từ.
•	Part 6 (Ngữ cảnh): Tập trung vào câu hỏi yêu cầu hiểu ý nghĩa của toàn đoạn văn.
•	Part 7 (Đọc hiểu): Luyện tập câu suy luận và tìm thông tin nhanh.
________________________________________
4. Kế hoạch học tập chi tiết
•	Theo tuần:
o	Gợi ý tài liệu học (ETS TOEIC, Hacker TOEIC).
o	Phân bổ thời gian cụ thể:
	Listening: Luyện tập kỹ năng nghe Part 3, 4.
	Reading: Luyện Part 7 với thời gian giới hạn để cải thiện tốc độ.
o	Phương pháp học:
	Luyện nghe shadowing để cải thiện tốc độ bắt từ khóa.
	Làm bài tập mô phỏng dưới áp lực thời gian.
________________________________________
5. Chiến lược tổng thể
•	Quản lý thời gian: Đặt giới hạn thời gian khi luyện tập Reading.
•	Mẹo làm bài: Làm các câu dễ trước, tránh sa lầy vào câu khó.
•	Động lực: Theo dõi tiến bộ qua từng tuần và khen thưởng bản thân khi đạt mục tiêu nhỏ.
`;
  if (targetScore) {
    return haveTargetScore;
  }
  return notHaveTargetScore;
};
export const modelAIRecommend = genAI.getGenerativeModel({
  model: "gemini-1.5-flash",
  // generationConfig: {
  //   responseMimeType: "application/json",
  //   responseSchema: schema,
  // },
});
