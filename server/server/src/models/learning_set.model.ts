import mongoose from "mongoose";
import { LearningFlashcardAttr } from "./learning_flashcard";
const { Schema } = mongoose;

// Define interface for LearningSet attributes
export interface LearningSetAttr {
  userId: string;
  setFlashcardId: string;
  status: string;
  lastStudied?: Date;
}

// Define interface for LearningSet document
export interface LearningSetDoc extends mongoose.Document {
  userId: string;
  setFlashcardId: string;
  status: string;
  lastStudied?: Date;
  learningFlashcards: LearningFlashcardAttr[];
}

// Define interface for LearningSet model
export interface LearningSetModel extends mongoose.Model<LearningSetDoc> {}

// Schema definition for LearningSet
const learningSetSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    setFlashcardId: {
      type: Schema.Types.ObjectId,
      ref: "SetFlashcard",
      required: true,
    },
    status: {
      type: String,
    },
    lastStudied: {
      type: Date,
      default: Date.now,
    },
  },
  {
    timestamps: true,
    toObject: {
      virtuals: true,
    },
    toJSON: {
      virtuals: true,
      transform(doc, ret) {
        ret.id = ret._id;
        delete ret._id;
        delete ret.__v;
      },
    },
  }
);
learningSetSchema.virtual("learningFlashcards", {
  ref: "LearningFlashcard",
  localField: "_id",
  foreignField: "learningSetId",
});
// Create model from schema
export const learningSetModel = mongoose.model<
  LearningSetDoc,
  LearningSetModel
>("LearningSet", learningSetSchema);
