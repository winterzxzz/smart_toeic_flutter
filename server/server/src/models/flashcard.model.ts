import mongoose from "mongoose";
import { PartOfSpeech } from "../configs/enum";

const { Schema } = mongoose;

// Định nghĩa interface cho flashcard
export interface FlashcardAttr {
  word: string; // Thay text bằng word
  translation: string;
  setFlashcardId: string;
  definition?: string;
  exampleSentence?: string[];
  note?: string;
  partOfSpeech?: PartOfSpeech[];
  pronunciation?: string;
}

// Định nghĩa interface cho tài liệu flashcard (Document)
export interface FlashcardDoc extends mongoose.Document {
  word: string;
  translation: string;
  setFlashcardId: string;
  definition?: string;
  exampleSentence?: string[];
  note?: string;
  partOfSpeech?: PartOfSpeech[];

  pronunciation?: string;
}

// Định nghĩa interface cho model flashcard
export interface FlashcardModel extends mongoose.Model<FlashcardDoc> {}

// Định nghĩa schema cho flashcard
const flashcardSchema = new Schema(
  {
    setFlashcardId: {
      type: Schema.Types.ObjectId,
      ref: "SetFlashcard",
      required: true,
    },
    word: {
      type: String,
      required: true,
    },
    translation: {
      type: String,
      required: true,
    },
    definition: {
      type: String,
    },
    exampleSentence: {
      type: [String], // Mảng chuỗi
    },
    note: {
      type: String,
    },
    partOfSpeech: {
      type: [String], // Thay đổi thành mảng chuỗi
      enum: Object.values(PartOfSpeech), // Giới hạn loại từ bằng enum
    },
    pronunciation: {
      type: String,
    },
  },
  {
    timestamps: true, // Tự động thêm createdAt và updatedAt
    toJSON: {
      transform(doc, ret) {
        ret.id = ret._id; // Tạo trường id từ _id
        delete ret._id; // Xóa trường _id
        delete ret.__v; // Xóa trường __v
      },
    },
  }
);

// Tạo model từ schema
export const flashcardModel = mongoose.model<FlashcardDoc, FlashcardModel>(
  "Flashcard",
  flashcardSchema
);
