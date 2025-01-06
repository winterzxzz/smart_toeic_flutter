import mongoose from "mongoose";
import { constEnv } from "../configs/const";
export async function connectMongo() {
  try {
    console.log("Connecting to: ", constEnv.mongoUrl);
    mongoose.set("debug", true);

    await mongoose.connect(constEnv.mongoUrl!);
    console.log("Connect mongodb success");
  } catch (error: unknown) {
    console.log(error);
  }
}
