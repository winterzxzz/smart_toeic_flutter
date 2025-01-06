import { Response } from "express";
import cookieSession from "cookie-session";

import cors from "cors";
import { handleError } from "./middlewares/handle_error";
import { passportA, passportU } from "./configs/passport";
import routerU from "./routes/user";
import routerA from "./routes/admin";
import routerP from "./routes/pub";
import path from 'path'
const express = require("express");
const app = express();
app.set("trust proxy", true);
const corsOptions = {
  origin: (
    origin: string | undefined,
    callback: (err: Error | null, allow?: boolean) => void
  ) => {
    callback(null, true);
  },
  credentials: true,
};
app.use(cors(corsOptions));

// app.use(
//   cookieSession({
//     signed: false,
//     // secure: true, // must be connect in https connection
//   })
// );
app.use(
  "/",
  cookieSession({
    name: "pub",
    signed: false,
    // secure: true, // must be connect in https connection
  })
);
app.use(
  "/api/user",
  cookieSession({
    name: "user-session",
    signed: false,
    // secure: true, // must be connect in https connection
  })
);
app.use(
  "/api/admin",
  cookieSession({
    name: "admin-session",
    signed: false,
    // secure: true, // must be connect in https connection
  })
);

app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(passportA.initialize({ userProperty: "user" }));
app.use(passportA.session());
app.use(passportU.initialize({ userProperty: "user" }));
app.use(passportU.session());
app.use("/api/user", routerU);
app.use("/api/admin", routerA);
app.use("/api/pub", routerP);
app.use("/test", (req: Request, res: Response) => {
  res.json("test");
});

app.use(handleError);
export default app;
