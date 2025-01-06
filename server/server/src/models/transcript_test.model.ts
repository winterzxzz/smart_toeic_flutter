import mongoose from "mongoose";
import { AccountType, TestType } from "../configs/enum";
const { Schema } = mongoose;
export interface TranscriptTestAttempt {
  userId: string;
  progress: number;
}
export interface TranscriptTestAttr {
  title: string;
  description?: string;
  url: string;
  attempts?: TranscriptTestAttempt[];
  code?: string;
}

export interface TranscriptTestDoc extends mongoose.Document {
  title: string;
  url: string;
  attempts?: TranscriptTestAttempt[];
  code?: string;
  description?: string;
}
export interface TranscriptTestModel
  extends mongoose.Model<TranscriptTestDoc> {}
const transcriptTestSchema = new Schema(
  {
    title: {
      type: String,
      require: true,
    },
    url: {
      type: String,
      require: true,
    },
    attempts: {
      type: Array<TranscriptTestAttempt>,
      default: [],
    },
    image: {
      type: String,
      default: "",
    },
    code: {
      type: String,
      require: true,
    },
    description: {
      type: String,
      default: "",
    },
  },
  {
    // collection: "Test_collection",
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
export const transcriptTestModel = mongoose.model<
  TranscriptTestDoc,
  TranscriptTestModel
>("TranscriptTest", transcriptTestSchema);
