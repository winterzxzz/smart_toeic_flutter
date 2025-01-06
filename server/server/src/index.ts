import "dotenv/config";

import app from "./app";
import { connectMongo } from "./connect/mongo";
import { connectRedis } from "./connect/redis";
// import { testSendMail } from "./configs/nodemailer";
import { main } from "./configs/aichat/chatbot/main";
connectMongo();
connectRedis();
// main();
declare global {
  namespace Express {
    interface User {
      id: string;
      // Add other properties as needed
    }
  }
}

app.listen(4000, () => {
  console.log("Listening on 4000 :: server is running");
});
