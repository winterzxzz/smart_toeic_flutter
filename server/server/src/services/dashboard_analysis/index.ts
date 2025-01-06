import { blogModel } from "../../models/blog.model";
import { resultModel } from "../../models/result.model";
import { transactionModel } from "../../models/transaction.model";
import { userModel } from "../../models/user.model";

export const getAllAnalysisWithinNDaysSrv = async (n: number) => {
  const userUpgrades = await userModel.find({
    upgradeExpiredDate: {
      $gte: new Date(Date.now() - 1000 * 60 * 60 * 24 * n),
    },
  });
};
export const getNewUserWithinNDaysSrv = async (n: number) => {
  const users = await userModel.find({
    createdAt: {
      $gte: new Date(Date.now() - 1000 * 60 * 60 * 24 * n),
    },
  });
  const usersOld = await userModel.find({
    createdAt: {
      $lt: new Date(Date.now() - 1000 * 60 * 60 * 24 * n),
      $gte: new Date(Date.now() - 1000 * 60 * 60 * 24 * n * 2),
    },
  });
  return {
    current: users.length,
    previous: usersOld.length,
    percentage: Math.round(
      ((users.length - usersOld.length) / usersOld.length) * 100
    ),
  };
};
export const examAttemptWithinNDaysSrv = async (n: number) => {
  const exams = await resultModel.find({
    createdAt: {
      $gte: new Date(Date.now() - 1000 * 60 * 60 * 24 * n),
    },
  });
  const examsOld = await resultModel.find({
    createdAt: {
      $lt: new Date(Date.now() - 1000 * 60 * 60 * 24 * n),
      $gte: new Date(Date.now() - 1000 * 60 * 60 * 24 * n * 2),
    },
  });
  return {
    current: exams.length,
    previous: examsOld.length,
    percentage: Math.round(
      ((exams.length - examsOld.length) / examsOld.length) * 100
    ),
  };
};

export const getIncomeWithinNDaysSrv = async (n: number) => {
  const transactions = await transactionModel.find({
    createdAt: {
      $gte: new Date(Date.now() - 1000 * 60 * 60 * 24 * n),
    },
  });
  const transactionsOld = await transactionModel.find({
    createdAt: {
      $lt: new Date(Date.now() - 1000 * 60 * 60 * 24 * n),
      $gte: new Date(Date.now() - 1000 * 60 * 60 * 24 * n * 2),
    },
  });
  const income = transactions.reduce((acc, transaction) => {
    return acc + transaction.amount;
  }, 0);
  const incomeOld = transactionsOld.reduce((acc, transaction) => {
    return acc + transaction.amount;
  }, 0);
  return {
    current: income,
    previous: incomeOld,
    percentage: Math.round(((income - incomeOld) / incomeOld) * 100),
  };
};
