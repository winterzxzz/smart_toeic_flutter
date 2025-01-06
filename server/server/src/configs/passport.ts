//@ts-nocheck
import { Passport } from "passport";
import {
  Strategy as GoogleStrategy,
  Profile as ProfileGG,
  VerifyCallback as VerifyCallbackGG,
} from "passport-google-oauth20";
import {
  Strategy as FacebookStrategy,
  Profile as ProfileFB,
  VerifyFunction as VerifyCallbackFB,
} from "passport-facebook";

import { Strategy as LocalStrategy } from "passport-local";
import { userModel } from "../models/user.model";
import { UserType } from "./interface";
import { constEnv } from "./const";
import { userSrv } from "../services/user";
import { adminLocalLogin } from "../services/admin";
export const passportU = new Passport();
export const passportA = new Passport();
passportU.use(
  new GoogleStrategy(
    {
      clientID: constEnv.googleClientId!,
      clientSecret: constEnv.googleClientSecret!,
      callbackURL: "/api/user/auth/google-login/callback",
      scope: ["profile", "email"],
    },
    async function (
      accessToken: string,
      refreshToken: string,
      profile: ProfileGG,
      done: VerifyCallbackGG
    ) {
      const user = {
        id: profile.id,
        name: profile.displayName,
        email: profile.emails?.[0].value,
        avatar: profile._json.picture, // Google profile picture URL
      };
      if (!user.email) {
        throw new Error("Can not get email");
      }
      const userExisted = await userModel.findOne({
        email: user.email,
      });
      if (userExisted) {
        if (!userExisted.googleId) {
          userExisted.set({ googleId: user.id });
          await userExisted.save();
          return done(null, userExisted);
        }
        if (userExisted.googleId === user.id) {
          return done(null, userExisted);
        }
      }
      const createUser = await userSrv.googleCreate({
        name: user.name,
        googleId: user.id,
        email: user.email,
      });
      // Ở đây, bạn có thể lưu thông tin người dùng vào cơ sở dữ liệu
      return done(null, createUser);
    }
  )
);
passportU.use(
  new FacebookStrategy(
    {
      clientID: constEnv.facebookClientId!,
      clientSecret: constEnv.facebookClientSecret!,
      callbackURL:
        "http://localhost:4000/api/user/auth/facebook-login/callback",
      profileFields: ["id", "displayName", "emails", "photos"], // Specify the fields you want to get
    },
    function (
      accessToken: string,
      refreshToken: string,
      profile: ProfileFB,
      done
    ) {
      // Extract user information
      const user = {
        id: profile.id,
        name: profile.displayName,
        email: profile.emails?.[0].value, // Safely access email
        avatar: profile._json.picture.data.url, // Facebook profile picture URL
      };

      return done(null, user);
    }
  )
);
passportU.use(
  "local",
  new LocalStrategy(
    { usernameField: "email", passwordField: "password" },
    async function (email: string, password: string, done) {
      try {
        const user = await userSrv.localLogin({
          email,
          password,
        });

        return done(null, user);
      } catch (error) {
        return done(error, false);
      }
      // Xử lý logic xác thực cho local
    }
  )
);

// Serialize và deserialize user để lưu thông tin vào session
passportU.serializeUser(function (user, done) {
  done(null, user);
});

passportU.deserializeUser(function (obj: UserType, done) {
  done(null, obj);
});

// passport for admin

passportA.use(
  "local",
  new LocalStrategy(
    { usernameField: "email", passwordField: "password" },
    async function (email: string, password: string, done) {
      // Xử lý logic xác thực cho client
      try {
        const user = await adminLocalLogin({ email, password });
        return done(null, user);
      } catch (error) {
        return done(error, false);
      }
    }
  )
);

// Serialize và deserialize user để lưu thông tin vào session
passportA.serializeUser(function (user, done) {
  done(null, user);
});

passportA.deserializeUser(function (obj: UserType, done) {
  done(null, obj);
});
