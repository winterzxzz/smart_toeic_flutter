const fs = require("fs");
const path = require("path");

function renameFilesInDirectory(directory) {
  fs.readdir(directory, (err, files) => {
    if (err) {
      console.error("Lỗi đọc thư mục:", err);
      return;
    }

    files.forEach((file) => {
      const filePath = path.join(directory, file);
      const newFileName = file.replace(/^\d+\./, ""); // Xóa phần đầu tiên trước dấu chấm
      const newFilePath = path.join(directory, newFileName);

      if (newFileName !== file) {
        fs.rename(filePath, newFilePath, (err) => {
          if (err) {
            console.error(`Lỗi khi đổi tên ${file} thành ${newFileName}:`, err);
          } else {
            console.log(`Đã đổi tên ${file} thành ${newFileName}`);
          }
        });
      }
    });
  });
}

// Sử dụng hàm, thay đổi đường dẫn tới thư mục của bạn
renameFilesInDirectory(
  "D:\\Code\\Project\\toeic_prep\\server\\src\\uploads\\audios\\523625"
);
// Đã đổi tên 2.num1.mp3 thành num1.mp3
// Đã đổi tên 2.num10.mp3 thành num10.mp3
// Đã đổi tên 2.num11.mp3 thành num11.mp3
