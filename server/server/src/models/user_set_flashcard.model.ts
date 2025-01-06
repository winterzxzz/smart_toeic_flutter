import mongoose from "mongoose";
import { StatusUserSetFC } from "../configs/enum";
const { Schema } = mongoose;
export interface UserSetFlashcardAttr {
  userId: string;
  setFlashcardId: string;
  status: StatusUserSetFC;
}
export interface UserSetFlashcardDoc extends mongoose.Document {
  userId: string;
  setFlashcardId: string;
  status: StatusUserSetFC;
}
export interface UserSetFlashcardModel
  extends mongoose.Model<UserSetFlashcardDoc> {}
const userSetFlashcardSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    setFlashcardId: {
      type: Schema.Types.ObjectId,
      required: true,
      ref: "SetFlashcard",
    },
    status: {
      type: String,
      enum: Object.values(StatusUserSetFC),
      required: true,
    },
  },
  {
    // collection: "UserSetFlashcard_collection",
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
export const userSetFlashcardModel = mongoose.model<
  UserSetFlashcardDoc,
  UserSetFlashcardModel
>("UserSetFlashcard", userSetFlashcardSchema);
