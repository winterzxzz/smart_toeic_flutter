import mongoose from "mongoose";
import { PartOfSpeech } from "../configs/enum";
import { UserTargetScore } from "./user.model";
const { Schema } = mongoose;

// Định nghĩa interface cho flashcard
export interface RecommendAttr {
  content: string;
  targetScore: UserTargetScore;
  userId: string;
}

// Định nghĩa interface cho tài liệu flashcard (Document)
export interface RecommendDoc extends mongoose.Document {
  content: string;
  targetScore: UserTargetScore;
  userId: string;
}

// Định nghĩa interface cho model flashcard
export interface RecommendModel extends mongoose.Model<RecommendDoc> {}

// Định nghĩa schema cho flashcard
const recommendSchema = new Schema(
  {
    content: {
      type: String,
      required: true,
    },
    targetScore: {
      type: Object,
      required: true,
    },
    userId: {
      type: String,
      required: true,
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

export const recommendModel = mongoose.model<RecommendDoc, RecommendModel>(
  "Recommend",
  recommendSchema
);
