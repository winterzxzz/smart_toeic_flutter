import nodemailer from "nodemailer";
import { constEnv } from "./const";
import { changePwMailTemp } from "../utils/mail_temp/mail.change-pw.temp";
import { verifyMailTemp } from "../utils/mail_temp/mail.verify.temp";
export const transport = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: constEnv.nodemailerUser,
    pass: constEnv.nodemailerPass,
  },
});

// async..await is not allowed in global scope, must use a wrapper
export async function sendMailChangePW(data: { to: string; otp: string }) {
  try {
    const info = await transport.sendMail({
      from: "hauhpll1231@gmail.com", // sender address
      to: data.to, // list of receivers
      subject: "Toeic Journey - Change your password", // Subject line
      html: changePwMailTemp(data.otp, data.to), // html body
    });

    console.log("Message sent: %s", info.messageId);
    // Message sent: <d786aa62-4e0a-070a-47ed-0b0666549519@ethereal.email>
  } catch (error) {
    console.log(error);
  }
  // send mail with defined transport object
}
export async function sendMailVerifyEmail(data: { to: string; otp: string }) {
  try {
    const info = await transport.sendMail({
      from: "hauhpll1231@gmail.com", // sender address
      to: data.to, // list of receivers
      subject: "Toeic Journey - Verify your email", // Subject line
      html: verifyMailTemp(data.otp, data.to), // html body
    });

    console.log("Message sent: %s", info.messageId);
    // Message sent: <d786aa62-4e0a-070a-47ed-0b0666549519@ethereal.email>
  } catch (error) {
    console.log(error);
  }
  // send mail with defined transport object
}
