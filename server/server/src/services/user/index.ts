import { UserAttr, userModel, UserTargetScore } from "../../models/user.model";
import bcrypt from "bcrypt";
import * as _ from "lodash";
import jwt from "jsonwebtoken";
import { constEnv } from "../../configs/const";
import { BadRequestError } from "../../errors/bad_request_error";
import { transactionModel } from "../../models/transaction.model";
import { formatDate, getStartOfPeriod } from "../../utils";
async function localCreate(data: {
  email: string;
  password: string;
  name: string;
}) {
  const checkEmail = await userModel.findOne({ email: data.email });

  if (checkEmail) {
    throw new BadRequestError("Email in use");
  }
  data.password = await bcrypt.hash(
    data.password,
    parseInt(constEnv.passwordSalt!)
  );
  // Store hash in your password DB.
  const user = await userModel.create(data);

  return user;
}
async function googleCreate(data: {
  googleId: string;
  name: string;
  email: string;
}) {
  const user = await userModel.create(data);
  return user;
}
async function facebookCreate(data: { facebookId: string; name: string }) {
  const user = await userModel.create(data);
  return user;
}
async function localLogin(data: { email: string; password: string }) {
  const user = await userModel.findOne({
    email: data.email,
  });
  if (!user) {
    throw new BadRequestError("Email or password is wrong");
  }
  const verify = await bcrypt.compare(data.password, user.password as string);

  if (!verify) {
    throw new BadRequestError("Email or password is wrong");
  }

  return user;
}
async function updateAvatar(id: string, avatar: string) {
  const user = await userModel.findByIdAndUpdate(id, { avatar }, { new: true });
  return user;
}
async function updateProfile(id: string, data: { name: string; bio: string }) {
  const user = await userModel.findByIdAndUpdate(id, data, { new: true });
  return user;
}
export async function getById(id: string) {
  const user = await userModel.findById(id).select("-password");
  return user;
}
export async function updateTargetScore(
  id: string,
  { reading, listening }: { reading: number; listening: number }
) {
  const targetScore = {
    reading,
    listening,
  };
  const user = await userModel.findByIdAndUpdate(
    id,
    { targetScore },
    {
      new: true,
    }
  );
  return user;
}
export async function getAllUsers() {
  const users = await userModel.find({}).select("-password");

  return users;
}
export async function getUpgradeUsers() {
  const users = await userModel.find({
    upgradeExpiredDate: { $gt: new Date() },
  });
  return users;
}

export async function getTotalUserAnalyst() {
  const totalUser = await userModel.countDocuments();
  return totalUser;
}
export async function getNewUserAnalyst(step: number, num: number) {
  // Lấy ngày hiện tại
  // Lấy ngày hiện tại
  const currentDate = new Date();

  // Tính ngày bắt đầu
  const startDate = new Date(currentDate);
  startDate.setDate(currentDate.getDate() - step * num);
  const periodStart = getStartOfPeriod(startDate, step);

  const result = await userModel.aggregate([
    {
      // Lọc các user được tạo từ startDate
      $match: {
        createdAt: { $gte: periodStart },
      },
    },
    {
      // Thêm trường period để nhóm
      $addFields: {
        periodStart: {
          $subtract: [
            { $toDate: "$createdAt" },
            {
              $mod: [
                { $subtract: [{ $toDate: "$createdAt" }, periodStart] },
                step * 24 * 60 * 60 * 1000,
              ],
            },
          ],
        },
      },
    },
    {
      // Nhóm theo period
      $group: {
        _id: "$periodStart",
        count: { $sum: 1 },
      },
    },
    {
      // Sắp xếp theo thời gian
      $sort: {
        _id: 1,
      },
    },
  ]);

  // Format lại kết quả
  const formattedResult = [];
  let currentPeriod = new Date(periodStart);

  for (let i = 0; i < num; i++) {
    const periodEnd = new Date(currentPeriod);
    periodEnd.setDate(periodEnd.getDate() + step - 1);

    // Tìm data tương ứng trong result
    const periodData = result.find(
      (item) => item._id.getTime() === currentPeriod.getTime()
    );

    formattedResult.push({
      period: `${formatDate(currentPeriod)} - ${formatDate(periodEnd)}`,
      startDate: currentPeriod.toISOString(),
      endDate: periodEnd.toISOString(),
      count: periodData ? periodData.count : 0,
    });

    // Chuyển sang period tiếp theo
    currentPeriod.setDate(currentPeriod.getDate() + step);
  }

  return formattedResult;
}
export async function getUpgradeUserAnalyst(step: number, num: number) {
  // Lấy ngày hiện tại
  const currentDate = new Date();

  // Tính ngày bắt đầu
  const startDate = new Date(currentDate);
  startDate.setDate(currentDate.getDate() - step * num);
  const periodStart = getStartOfPeriod(startDate, step);

  const result = await transactionModel.aggregate([
    {
      // Lọc các transaction từ startDate
      $match: {
        createdAt: { $gte: periodStart },
      },
    },
    {
      // Thêm trường period để nhóm
      $addFields: {
        periodStart: {
          $subtract: [
            { $toDate: "$createdAt" },
            {
              $mod: [
                { $subtract: [{ $toDate: "$createdAt" }, periodStart] },
                step * 24 * 60 * 60 * 1000,
              ],
            },
          ],
        },
      },
    },
    {
      // Nhóm theo period và đếm số lượng userId unique
      $group: {
        _id: {
          period: "$periodStart",
          userId: "$userId", // Thêm userId vào _id để nhóm
        },
      },
    },
    {
      // Nhóm lại theo period và đếm số lượng unique users
      $group: {
        _id: "$_id.period",
        count: { $sum: 1 }, // Đếm số lượng nhóm unique (userId)
      },
    },
    {
      // Sắp xếp theo thời gian
      $sort: {
        _id: 1,
      },
    },
  ]);

  // Format lại kết quả
  const formattedResult = [];
  let currentPeriod = new Date(periodStart);

  for (let i = 0; i < num; i++) {
    const periodEnd = new Date(currentPeriod);
    periodEnd.setDate(periodEnd.getDate() + step - 1);

    // Tìm data tương ứng trong result
    const periodData = result.find(
      (item) => item._id.getTime() === currentPeriod.getTime()
    );

    formattedResult.push({
      period: `${formatDate(currentPeriod)} - ${formatDate(periodEnd)}`,
      startDate: currentPeriod.toISOString(),
      endDate: periodEnd.toISOString(),
      count: periodData ? periodData.count : 0,
    });

    // Chuyển sang period tiếp theo
    currentPeriod.setDate(currentPeriod.getDate() + step);
  }

  return formattedResult;
}
export async function getUserProgressAnalyst() {
  const totalUser = await userModel.find({}).countDocuments();
  const premiumUser = await userModel
    .find({
      upgradeExpiredDate: { $gt: new Date() },
    })
    .countDocuments();

  return { totalUser, premiumUser };
}
export const userSrv = {
  localCreate,
  localLogin,
  googleCreate,
  facebookCreate,
  getById,
  updateProfile,
  updateAvatar,
  updateTargetScore,
  getAllUsers,
  getUpgradeUsers,
  getNewUserAnalyst,
  getUpgradeUserAnalyst,
  getUserProgressAnalyst,
};
export async function hashPassword(password: string) {
  return await bcrypt.hash(password, parseInt(constEnv.passwordSalt!));
}
