import mongoose from "mongoose";
import { TransactionStatus, TransactionType } from "../configs/enum";
const { Schema } = mongoose;

export interface TransactionAttr {
  amount: number;
  currency: string;
  type: TransactionType;
  description: string;
  userId: string;
  providerId: string;
  status: TransactionStatus;
}

export interface TransactionDoc extends mongoose.Document {
  amount: number;
  currency: string;
  type: TransactionType;
  description: string;
  userId: string;
  providerId: string;
  status: TransactionStatus;
  createdAt: Date;
  updatedAt: Date;
}
export interface TransactionModel extends mongoose.Model<TransactionDoc> {}
const transactionSchema = new Schema(
  {
    amount: { type: Number, required: true },
    currency: { type: String, required: true, default: "VND" },
    type: { type: String, required: true },
    description: { type: String },
    userId: { type: String, required: true },
    providerId: { type: String, required: true },
    status: {
      type: String,
      required: true,
      default: TransactionStatus.pending,
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
export const transactionModel = mongoose.model<
  TransactionDoc,
  TransactionModel
>("Transaction", transactionSchema);
