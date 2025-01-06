import crypto from "crypto";
import { LearningFlashcardAttr } from "../models/learning_flashcard";
export * from "./otp.generate";

export const delay = (ms: number) =>
  new Promise((resolve) => setTimeout(resolve, ms));
export function generateMac(data: string, key: string) {
  return crypto
    .createHmac("sha256", key) // Sử dụng HMAC với SHA-256
    .update(data) // Cập nhật dữ liệu đầu vào
    .digest("hex"); // Chuyển đổi kết quả thành chuỗi hexa
}
function getDiffDays(optimalTime: Date) {
  return (
    (new Date(optimalTime).getTime() - new Date().getTime()) /
    (1000 * 60 * 60 * 24)
  );
}
export function getRateDiffDays(learningFlashcard: LearningFlashcardAttr) {
  if (!learningFlashcard.optimalTime || !learningFlashcard.interval) {
    return 0.2;
  }
  // Tính số ngày khác biệt giữa optimalTime và ngày hiện tại
  const diffDays = getDiffDays(learningFlashcard.optimalTime);

  // Tính tỉ lệ giữa diffDays và interval
  let rate = diffDays / learningFlashcard.interval;

  // Nếu tỉ lệ không hợp lệ, gán rate = 0.2
  if (!isFinite(rate)) {
    rate = 0.2;
  }

  return rate;
}
export function getTimeLastNDays(n: number) {
  const today = new Date();
  today.setHours(23, 59, 59, 999);
  const nDaysAgo = new Date();
  nDaysAgo.setDate(today.getDate() - n);
  nDaysAgo.setHours(0, 0, 0, 0);
  return { from: nDaysAgo, to: today };
}
export function cleanNullFieldObject(obj: any) {
  return Object.fromEntries(Object.entries(obj).filter(([_, v]) => v !== null));
}
export function getStartOfPeriod(date: Date, step: number) {
  const newDate = new Date(date);
  newDate.setHours(0, 0, 0, 0);
  return newDate;
}
export function formatDate(date: Date) {
  return `${date.getDate()}/${date.getMonth() + 1}/${date.getFullYear()}`;
}
