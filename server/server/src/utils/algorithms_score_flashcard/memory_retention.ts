export class MemoryRetention {
  k: number;
  C: number;
  /**
   * Khởi tạo lớp với các tham số cơ bản.
   * @param {number} k - Hệ số suy giảm (mặc định: 0.2).
   * @param {number} C - Hệ số tăng cường học tập (mặc định: 0.2).
   */
  constructor(k = 0.2, C = 0.2) {
    this.k = k;
    this.C = C;
  }

  /**
   * Tính hệ số thời gian (T_f) dựa trên thời gian học.
   * @param {number} studyTime - Thời gian học (phút).
   * @returns {number} Hệ số thời gian (T_f).
   */
  calculateTimeFactor(studyTime: number) {
    if (studyTime <= 1) {
      return 0.5;
    } else if (studyTime <= 5) {
      return 0.7;
    } else if (studyTime <= 30) {
      return 0.9;
    } else {
      return 1.0;
    }
  }

  /**
   * Tính độ chính xác (A).
   * @param {number} correct - Số câu trả lời đúng.
   * @param {number} total - Tổng số câu hỏi.
   * @returns {number} Độ chính xác (A).
   */

  /**
   * Tính toán \( S_{\text{new}} \).
   * @param {number} t - Thời điểm ôn tập hiện tại.
   * @param {number} studyTime - Thời gian học (phút).
   * @param {number} correct - Số câu trả lời đúng.
   * @param {number} total - Tổng số câu hỏi.
   * @returns {number} Độ mạnh trí nhớ sau ôn tập (S_new).
   */
  calculateNewMemoryRetention(
    currentStrength: number,
    optimalTime: number,
    t_actual: number,
    studyTime: number,
    accuracy: number
  ) {
    const T_f = this.calculateTimeFactor(studyTime);

    const E = accuracy * T_f;
    const decayFactor = Math.exp(-this.k * Math.pow(t_actual - optimalTime, 2));

    return currentStrength * (1 + this.C * decayFactor * E);
  }
}

// Sử dụng ví dụ:
// const memory = new MemoryRetention(0.8, 24, 0.1, 0.2); // S_current = 0.8, t_optimal = 24 giờ
// const S_new = memory.calculateNewMemoryRetention(25, 10, 0.8); // t = 25 giờ, học trong 10 phút, đúng 8/10 câu
// console.log("Độ mạnh trí nhớ mới (S_new):", S_new.toFixed(4));
