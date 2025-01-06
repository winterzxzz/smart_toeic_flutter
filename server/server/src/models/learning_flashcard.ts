import mongoose from "mongoose";
const { Schema } = mongoose;

// Define interface for LearningFlashcard attributes
export interface LearningFlashcardAttr {
  flashcardId: string;
  retentionScore: number; // K
  decayScore: number; //e^(-k*t)
  lastStudied: Date;
  studyTime: number;
  EF: number;
  learningSetId: string;
  optimalTime?: Date; // thời gian học tối ưu tính từ lần học trước(ngày)
  interval?: number; // khoảng thời gian học tối ưu tính từ lần học trước(ngày)
}

// Define interface for LearningFlashcard document
export interface LearningFlashcardDoc extends mongoose.Document {
  flashcardId: string;
  retentionScore: number; // K
  decayScore: number; //e^(-k*t)
  lastStudied: Date;
  studyTime: number;
  EF: number;
  learningSetId: string;
  optimalTime?: Date; // thời gian học tối ưu tính từ lần học trước(ngày)
  interval?: number; // khoảng thời gian học tối ưu tính từ lần học trước(ngày)
}

// Define interface for LearningFlashcard model
export interface LearningFlashcardModel
  extends mongoose.Model<LearningFlashcardDoc> {}

// Schema definition for LearningFlashcard
const learningFlashcardSchema = new Schema(
  {
    flashcardId: {
      type: Schema.Types.ObjectId,
      ref: "Flashcard",
      unique: true,
      required: true,
    },
    retentionScore: {
      type: Number,
      default: 0,
    },
    decayScore: {
      type: Number,
      default: 0,
    },
    lastStudied: {
      type: Date,
      default: Date.now,
    },
    studyTime: {
      type: Number,
      default: 0,
    },
    EF: {
      type: Number,
      default: 1.8,
    },
    learningSetId: {
      type: String,
      required: true,
      ref: "LearningSet",
    },
    optimalTime: {
      type: Date,
      default: null,
    },
    interval: {
      type: Number,
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

// Create model from schema
export const learningFlashcardModel = mongoose.model<
  LearningFlashcardDoc,
  LearningFlashcardModel
>("LearningFlashcard", learningFlashcardSchema);
