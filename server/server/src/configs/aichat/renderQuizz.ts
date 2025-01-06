import { GoogleGenerativeAI, SchemaType } from "@google/generative-ai";
import { genAI } from "./instance";

const schema = {
  description: "Generate quiz questions for flashcards with their IDs",
  type: SchemaType.ARRAY,
  items: {
    type: SchemaType.OBJECT,
    properties: {
      flashcardId: { type: SchemaType.STRING, description: "Flashcard ID" },
      word: { type: SchemaType.STRING, description: "The word" },
      quiz: {
        type: SchemaType.OBJECT,
        properties: {
          question: { type: SchemaType.STRING, description: "Quiz question" },
          options: {
            type: SchemaType.ARRAY,
            items: { type: SchemaType.STRING },
            description: "Four answer options",
          },
          correctAnswer: {
            type: SchemaType.STRING,
            description: "The correct answer",
          },
        },
        required: ["question", "options", "correctAnswer"],
      },
    },
    required: ["flashcardId", "word", "quiz"],
  },
};
export const modelAIQuizz = genAI.getGenerativeModel({
  model: "gemini-1.5-pro",
  generationConfig: {
    responseMimeType: "application/json",
    responseSchema: schema,
  },
});
