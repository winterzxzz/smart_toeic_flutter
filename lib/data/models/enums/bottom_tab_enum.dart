enum BottomTabEnum {
  gioiThieu,
  deThiOnline,
  flashCards,
  blog,
  kichHoatTaiKhoan
}

extension BottomTabEnumExtension on BottomTabEnum {
  String get title {
    switch (this) {
      case BottomTabEnum.gioiThieu:
        return 'Giới thiệu';
      case BottomTabEnum.deThiOnline:
        return 'Đề thi online';
      case BottomTabEnum.flashCards:
        return 'FlashCards';
      case BottomTabEnum.blog:
        return 'Blog';
      case BottomTabEnum.kichHoatTaiKhoan:
        return 'Kích hoạt tài khoản';
    }
  }

  int get index {
    switch (this) {
      case BottomTabEnum.gioiThieu:
        return 0;
      case BottomTabEnum.deThiOnline:
        return 1;
      case BottomTabEnum.flashCards:
        return 2;
      case BottomTabEnum.blog:
        return 3;
      case BottomTabEnum.kichHoatTaiKhoan:
        return 4;
    }
  }
}
