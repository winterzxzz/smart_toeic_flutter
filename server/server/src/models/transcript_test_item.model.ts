import mongoose from "mongoose";
const { Schema } = mongoose;

export interface TranscriptTestItemAttr {
  transcriptTestId: string;
  audioUrl: string;
  transcript: string;
}

export interface TranscriptTestItemDoc extends mongoose.Document {
  transcriptTestId: string;
  audioUrl: string;
  transcript: string;
}
export interface TranscriptTestItemModel
  extends mongoose.Model<TranscriptTestItemDoc> {}
const transcriptTestItemSchema = new Schema(
  {
    transcriptTestId: {
      type: String,
      require: true,
      ref: "TranscriptTest",
    },
    audioUrl: {
      type: String,
      require: true,
    },
    transcript: {
      type: String,
      require: true,
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
export const transcriptTestItemModel = mongoose.model<
  TranscriptTestItemDoc,
  TranscriptTestItemModel
>("TranscriptTestItem", transcriptTestItemSchema);
