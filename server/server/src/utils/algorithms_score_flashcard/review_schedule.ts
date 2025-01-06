export class SuperMemo {
  constructor() {}

  // Cập nhật EF và Interval sau mỗi lần ôn tập
  countEF(EF: number, Q: number, difficult_rate: number): number {
    EF = EF + (0.1 - (5 - Q) * (0.08 + (5 - Q) * 0.02));
    EF = EF * Math.exp((difficult_rate - 0.5) * 0.7);
    if (EF < 1.3) {
      EF = 1.3;
    }
    if (EF > 2.5) {
      EF = 2.5;
    }
    return EF;
  }
  countInterval(
    EF: number, // Hiệu quả học tập (0-5)
    Q: number, // Hiệu quả học tập (0-5)
    n: number, // Số lần ôn tập,
    interval: number,
    difficult_rate: number
  ): number {
    // Cập nhật hệ số dễ dàng (EF)
    EF = this.countEF(EF, Q, difficult_rate);
    // Đảm bảo EF không nhỏ hơn 1.3
    // Cập nhật số lần ôn tập
    // Cập nhật Interval (I) tùy thuộc vào số lần ôn tập
    if (n === 1) {
      interval = 1; // Lần học đầu tiên
    } else if (n === 2) {
      interval = 6; // Lần học thứ 2
    } else if (n > 2) {
      interval = Math.round(interval * EF); // Lần học thứ 3 trở đi
    }

    // In kết quả
    // console.log(
    //   `Lần học thứ ${n}: EF = ${this.EF.toFixed(2)}, Interval = ${
    //     this.interval
    //   } ngày`
    // );
    return interval;
  }

  // Đánh giá độ nhớ và cập nhật
  review(
    EF: number,
    Q: number,
    n: number,
    interval: number,
    difficult_rate: number
  ): void {
    console.log(this.countInterval(EF, Q, n, interval, difficult_rate));
  }
}

// Tạo đối tượng SuperMemo
// const sm2 = new SuperMemo();

// // Ví dụ đánh giá độ nhớ với Q là 4 (đánh giá từ 0 đến 5) và n là số lần học
// sm2.review(4, 1); // Lần học đầu tiên

// // Giả sử bạn đánh giá lại lần học tiếp theo với Q là 5 và n là 2 (lần học thứ 2)
// sm2.review(5, 2); // Lần học thứ 2

// // Giả sử bạn đánh giá lại lần học tiếp theo với Q là 3 và n là 3 (lần học thứ 3)
// sm2.review(3, 3); // Lần học thứ 3

// // Giả sử bạn đánh giá lại lần học tiếp theo với Q là 4 và n là 4 (lần học thứ 4)
// sm2.review(4, 4); // Lần học thứ 4
