import { SuperMemo } from "./review_schedule";
import { calculateDecay } from "./calculate_decay";
import { MemoryRetention } from "./memory_retention";
export class AlgorithmsScoreFlashcard {
  superMemo: SuperMemo;
  n: number;
  t_actual: number;
  EF: number;
  Q: number;
  oldMemoryRetention: number;
  accuracy: number;
  timeMinutes: number;
  memoryRetentionInstance: MemoryRetention;
  newMemoryRetention: any;
  interval: number;
  difficult_rate: number;
  constructor(
    n: number, // số lần học
    t_actual: number, // thời gian thực tế
    EF: number, // hệ số dễ dàng,(1.3-2.5)
    Q: number, // Hiệu quả học tập (0-5)
    timeMinutes: number,
    accuracy: number,
    oldMemoryRetention: number,
    interval: number,
    difficult_rate: number
  ) {
    this.superMemo = new SuperMemo();
    this.memoryRetentionInstance = new MemoryRetention();
    this.n = n;
    this.t_actual = t_actual;
    this.EF = EF;
    this.Q = Q;
    this.oldMemoryRetention = oldMemoryRetention;
    this.timeMinutes = timeMinutes;
    this.accuracy = accuracy;
    this.interval = interval;
    this.difficult_rate = difficult_rate;
  }
  calculateDecay() {
    return calculateDecay(this.calculateMemoryRetention(), this.t_actual);
  }
  calculateOptimalTime(): number {
    return this.superMemo.countInterval(
      this.EF,
      this.Q,
      this.n,
      this.interval,
      this.difficult_rate
    );
  }
  calculateEF() {
    return this.superMemo.countEF(this.EF, this.Q, this.difficult_rate);
  }
  calculateMemoryRetention() {
    return this.memoryRetentionInstance.calculateNewMemoryRetention(
      this.oldMemoryRetention,
      this.interval,
      this.t_actual,
      this.timeMinutes,
      this.accuracy
    );
  }

  showAll() {
    console.log({
      interval: this.interval,
      t_actual: this.t_actual,
      EF: this.EF,
      Q: this.Q,
      n: this.n,
      newMemoryRetention: this.calculateMemoryRetention(),
      decay: this.calculateDecay(),
    });
  }
}
