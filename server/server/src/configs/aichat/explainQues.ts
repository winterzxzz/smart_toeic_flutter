import { GoogleGenerativeAI, SchemaType } from "@google/generative-ai";
import { genAI } from "./instance";

const schema = {
  description:
    "Tạo câu trả lời và giải thích cho câu hỏi trắc nghiệm bằng tiếng Việt",
  type: SchemaType.OBJECT,
  properties: {
    correctAnswer: { type: SchemaType.STRING, description: "Đáp án đúng" },
    options: {
      type: SchemaType.ARRAY,
      description: "Các đáp án",
      items: {
        type: SchemaType.OBJECT,
        properties: {
          label: {
            type: SchemaType.STRING,
            description: "Nhãn đáp án (A, B, C, D)",
          },
          text: { type: SchemaType.STRING, description: "Nội dung đáp án" },
        },
        required: ["label", "text"],
      },
    },
    explanation: {
      type: SchemaType.OBJECT,
      description: "Giải thích chi tiết",
      properties: {
        correctReason: {
          type: SchemaType.STRING,
          description: "Lý do đáp án đúng là chính xác",
        },
        incorrectReasons: {
          type: SchemaType.OBJECT,
          properties: {
            A: { type: SchemaType.STRING, description: "Lý do đáp án A sai" },
            B: { type: SchemaType.STRING, description: "Lý do đáp án B sai" },
            C: { type: SchemaType.STRING, description: "Lý do đáp án C sai" },
            D: { type: SchemaType.STRING, description: "Lý do đáp án D sai" },
          },
          required: ["A", "B", "C", "D"],
        },
      },
      required: ["correctReason", "incorrectReasons"],
    },
  },
  required: ["correctAnswer", "options", "explanation"],
};
export const explainAIModel = genAI.getGenerativeModel({
  model: "gemini-1.5-pro",
  generationConfig: {
    responseMimeType: "application/json",
    responseSchema: schema,
  },
});
