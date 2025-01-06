import mongoose from "mongoose";
import { Role } from "../configs/enum";
const { Schema } = mongoose;
export interface SetFlashcardAttr {
  //   id: string;
  userId: string;
  title: string;
  description?: string;
  isPublic?: boolean;
  userRole?: string;
  numberOfFlashcards?: number;
}
export interface SetFlashcardDoc extends mongoose.Document {
  userId: string;
  title: string;
  description?: string;
  isPublic?: boolean;
  numberOfFlashcards?: number;
}
export interface SetFlashcardModel extends mongoose.Model<SetFlashcardDoc> {}
const SetFlashcardSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    title: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      default: "",
    },
    isPublic: {
      type: Boolean,
      default: false,
    },
    userRole: {
      type: String,
      enum: Object.values(Role),
      required: true,
    },
    numberOfFlashcards: {
      type: Number,
      min: 0,
      default: 0,
    },
  },
  {
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
export const setFlashcardModel = mongoose.model<
  SetFlashcardDoc,
  SetFlashcardModel
>("SetFlashcard", SetFlashcardSchema);
