import { constEnv } from "../../configs/const";

export const verifyMailTemp = (otp: string, email: string) => {
  return `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Verify Your Email</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      padding: 0;
    }
    .email-container {
      max-width: 600px;
      margin: 50px auto;
      background-color: #fff;
      padding: 20px;
      border: 1px solid #e0e0e0;
    }
    h1 {
      text-align: center;
      font-size: 24px;
      color: #333;
    }
    p {
      font-size: 16px;
      color: #555;
      line-height: 1.5;
    }
    .button-container {
      text-align: center;
      margin: 20px 0;
    }
    .button-container a {
      display: inline-block;
      background-color: #000;
      color: #fff;
      padding: 12px 24px;
      text-decoration: none;
      border-radius: 5px;
      font-size: 18px;
      font-weight: 500;
    }
    .button-container a:hover {
      background-color: #444;
    }
    .fallback-link {
      text-align: center;
      margin-top: 10px;
      font-size: 14px;
      color: #555;
    }
    .footer {
      text-align: center;
      margin-top: 30px;
      font-size: 12px;
      color: #777;
      border-top: 1px solid #e0e0e0;
      padding-top: 10px;
    }
    .footer a {
      color: #555;
      text-decoration: none;
    }
  </style>
</head>
<body>
  <div class="email-container">
    <h1>Toeic Journey</h1>
    <p>Thank you for registering with us! To complete your registration and verify your email, please click the button below.</p>
    
    <div class="button-container">
      <a href="${constEnv.clientOrigin}/mail/verify/handle?otp=${otp}&email=${email}">Verify Email</a>
    </div>
    
    <p class="fallback-link">If the button doesn't work, copy and paste this link into your browser:</p>
    <p class="fallback-link"><a href="${constEnv.clientOrigin}/mail/verify/handle?otp=${otp}&email=${email}">${constEnv.clientOrigin}/mail/verify/handle?otp=${otp}&email=${email}</a></p>
    
    <div class="footer">
      <p>This email was sent by Toeic Journey<br>123 Company Street, City, Country</p>
      <p><a href="#">Unsubscribe</a> | <a href="#">Privacy Policy</a></p>
    </div>
  </div>
</body>
</html>
`;
};
