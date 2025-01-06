import mongoose from "mongoose";
import { AccountType, Role, UserStatus } from "../configs/enum";
const { Schema } = mongoose;
export interface WordAttr {
  word: string;
  translation: string;
  description: string;
}
export interface WordDoc extends mongoose.Document {
  word: string;
  translation: string;
  description: string;
}
export interface WordModel extends mongoose.Model<WordDoc> {}
const wordSchema = new Schema(
  {
    word: {
      type: String,
      unique: true,
    },
    translation: {
      type: String,
    },
    description: {
      type: String,
    },
  },
  {
    // collection: "user_collection",
    timestamps: true,
    toJSON: {
      transform(doc, ret) {
        ret.id = ret._id;
        delete ret._id;
        delete ret.__v;
      },
    },
  }
);

export const wordModel = mongoose.model<WordDoc, WordModel>("Word", wordSchema);
