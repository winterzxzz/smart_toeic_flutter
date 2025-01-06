import mongoose from "mongoose";
import { AccountType, TestType } from "../configs/enum";
const { Schema } = mongoose;
export interface TestAttempt {
  userId: string;
  times: number;
}
export interface TestAttr {
  title: string;
  url: string;
  type: TestType;
  attempts?: TestAttempt[];
  code?: string;
  numberOfParts: number;
  numberOfQuestions: number;
  duration: number;
  fileName: string;
  parts: number[];
  isPublished: boolean;
  difficulty: string;
}

export interface TestDoc extends mongoose.Document {
  title: string;
  url: string;
  type: TestType;
  attempts: TestAttempt[];
  code: string;
  numberOfParts: number;
  numberOfQuestions: number;
  duration: number;
  fileName: string;
  parts: number[];
  isPublished: boolean;
  difficulty: string;
}
export interface TestModel extends mongoose.Model<TestDoc> {}
const testSchema = new Schema(
  {
    title: {
      type: String,
      require: true,
    },
    url: {
      type: String,
      require: true,
    },
    type: {
      type: String,
      enum: TestType,
      require: true,
    },
    attempts: {
      type: Array<TestAttempt>,
      default: [],
    },
    numberOfParts: {
      type: Number,
    },
    parts: {
      type: [Number],
      default: [],
    },

    code: {
      type: String,
      require: true,
    },
    numberOfQuestions: {
      type: Number,
      require: true,
    },
    duration: {
      type: Number,
      require: true,
    },
    fileName: {
      type: String,
      require: true,
    },
    isPublished: {
      type: Boolean,
      default: false,
    },
    difficulty: {
      type: String,
      default: "intermediate",
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
export const testModel = mongoose.model<TestDoc, TestModel>("Test", testSchema);
