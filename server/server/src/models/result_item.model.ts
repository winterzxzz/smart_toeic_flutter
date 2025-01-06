import mongoose from "mongoose";
import { PartOfSpeech, TestType } from "../configs/enum";
const { Schema } = mongoose;

// Định nghĩa interface cho ResultItem
export interface ResultItemAttr {
  useranswer: string; // Câu trả lời của người dùng
  correctanswer: string; // Câu trả lời đúng
  userId: string; // Thay đổi type thành mảng chuỗi
  questionNum: string; // Số thứ tự câu hỏi
  testId: PartOfSpeech; // Thay đổi type thành enum PartOfSpeech
  testType: string; // Loại bài kiểm tra
  resultId: string; // ID kết quả
  part: number;
  isReading: boolean;
  timeSecond: number;
  questionCategory: string[];
}

// Định nghĩa interface cho tài liệu ResultItem (Document)
export interface ResultItemDoc extends mongoose.Document {
  useranswer: string; // Câu trả lời của người dùng
  correctanswer: string; // Câu trả lời đúng
  userId: string;
  questionNum: string; // Số thứ tự câu hỏi
  testId: PartOfSpeech; // Thay đổi type thành enum PartOfSpeech
  testType: string; // Loại bài kiểm tra
  resultId: string; // ID kết quả
  part: number;
  isReading: boolean;
  timeSecond: number;
  questionCategory: string[];
  createdAt: Date;
}

// Định nghĩa interface cho model ResultItem
export interface ResultItemModel extends mongoose.Model<ResultItemDoc> {}

// Định nghĩa schema cho ResultItem
const resultItemSchema = new Schema(
  {
    useranswer: {
      type: String,
      required: true,
    },
    correctanswer: {
      type: String,
      required: true,
    },
    userId: {
      type: Schema.Types.ObjectId, // Mảng chuỗi ID người dùng
      required: true,
      ref: "User",
    },
    questionNum: {
      type: String,
      required: true,
    },
    testId: {
      type: Schema.Types.ObjectId,
      required: true,
      ref: "Test",
    },
    testType: {
      type: String,
      enum: Object.values(TestType),
      required: true,
    },
    resultId: {
      type: Schema.Types.ObjectId,
      required: true,
      ref: "Result",
    },
    part: {
      type: Number,
    },
    isReading: {
      type: Boolean,
      default: true,
    },
    timeSecond: {
      type: Number,
      default: 0,
    },
    questionCategory: {
      type: [String], // Đảm bảo đây là một mảng các chuỗi
      default: [], // Giá trị mặc định là một mảng rỗng
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
export const resultItemModel = mongoose.model<ResultItemDoc, ResultItemModel>(
  "ResultItem",
  resultItemSchema
);
