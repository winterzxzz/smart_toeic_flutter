import { GoogleGenerativeAI, SchemaType } from "@google/generative-ai";
import { genAI } from "./instance";

const schema = {
  description: "Word details in a structured format",
  type: SchemaType.OBJECT,
  properties: {
    definition: {
      type: SchemaType.STRING,
      description: "Definition of the word",
      nullable: false,
    },
    example1: {
      type: SchemaType.STRING,
      description: "An example sentence for using the word",

      nullable: false,
    },
    example2: {
      type: SchemaType.STRING,
      description: "An example sentence for using the word",
      nullable: false,
    },
    note: {
      type: SchemaType.STRING,
      description: "Additional notes about the word usage",
      nullable: false,
    },
    partOfSpeech: {
      type: SchemaType.ARRAY,
      description: "The parts of speech the word can function as",
      items: {
        type: SchemaType.STRING,
      },
      nullable: false,
    },
    pronunciation: {
      type: SchemaType.STRING,
      description: "The pronunciation of the word",
      nullable: false,
    },
    translation: {
      type: SchemaType.STRING,
      description: "Translation of the word in vietnamese",
      nullable: false,
    },
    word: {
      type: SchemaType.STRING,
      description: "The word itself",
      nullable: false,
    },
  },
  required: [
    "definition",
    "example1",
    "example2",
    "note",
    "partOfSpeech",
    "pronunciation",
    "translation",
    "word",
  ],
};
export const modelAI = genAI.getGenerativeModel({
  model: "gemini-1.5-flash",
  generationConfig: {
    responseMimeType: "application/json",
    responseSchema: schema,
  },
});
