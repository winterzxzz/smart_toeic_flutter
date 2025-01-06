export function generateOTP() {
  let otp = "";
  for (let i = 0; i < 6; i++) {
    const random = Math.floor(Math.random() * 10);
    otp += random;
  }
  return otp;
}
