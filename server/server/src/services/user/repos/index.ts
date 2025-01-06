import { userModel } from "../../../models/user.model";
function isExpired(date: Date | undefined) {
  if (!date) return true;
  return date < new Date();
}
namespace UserRepo {
  export async function checkExist(id: string) {
    const is = await userModel.findById(id);
    return !!is;
  }
  export async function upgrade(id: string) {
    // Kiểm tra xem người dùng có tồn tại không
    const user = await userModel.findById(id);

    if (!user) {
      throw new Error("Người dùng không tồn tại"); // Nếu không tồn tại, throw lỗi
    }
    if (isExpired(user.upgradeExpiredDate)) {
      // Sử dụng findOneAndUpdate để cập nhật upgradeExpiredDate
      const updatedUser = await userModel.findOneAndUpdate(
        { _id: id }, // Tìm người dùng theo ID
        {
          $set: {
            upgradeExpiredDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 ngày
          },
        },
        { new: true } // Trả về bản ghi đã được cập nhật
      );

      return updatedUser;
    } else {
      const updatedUser = await userModel.findOneAndUpdate(
        { _id: id }, // Tìm người dùng theo ID
        {
          $set: {
            upgradeExpiredDate: new Date(
              user.upgradeExpiredDate!.getTime() + 30 * 24 * 60 * 60 * 1000
            ), // Cộng thêm 30 ngày
          },
        },
        { new: true } // Trả về bản ghi đã được cập nhật
      );
      return updatedUser;
    }
  }
}
export default UserRepo;
