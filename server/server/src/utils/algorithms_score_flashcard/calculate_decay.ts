export function calculateDecay(s: number, t: number) {
  // Tính toán giá trị R theo công thức R = R0 * e^(-kt)
  // R0 = 1 vì đây là giá trị ban đầu
  return 1 * Math.exp(-t / s);
}
