enum CameraType {
  qrcode,
  documents,
  gcndn,
  cccd,
  cccdChip,
  gplx,
  dangKyXeMaySau2015,
  dangKyOtoXeMaySau2021,
  dangKiem,
  hoChieu,
  hoaDonBan,
  admin,
}

extension CameraTypeEx on CameraType {
  String get name {
    switch (this) {
      case CameraType.qrcode:
        return 'QR CODE';
      case CameraType.documents:
        return 'DOCUMENTS';
      case CameraType.gcndn:
        return 'GCNDN';
      case CameraType.admin:
        return 'ADMIN';
      case CameraType.cccd:
        return 'CCCD';
      case CameraType.cccdChip:
        return 'CCCD CHIP';
      case CameraType.gplx:
        return 'GPLX';
      case CameraType.dangKyXeMaySau2015:
        return 'ĐĂNG KÝ XE MÁY';
      case CameraType.dangKyOtoXeMaySau2021:
        return 'ĐĂNG KÝ Ô TÔ';
      case CameraType.dangKiem:
        return 'ĐĂNG KIỂM';
      case CameraType.hoChieu:
        return 'HỘ CHIẾU';
      case CameraType.hoaDonBan:
        return 'HÓA ĐƠN BÁN';
      default:
        return 'DOCUMENTS';
    }
  }

  String get value {
    switch (this) {
      case CameraType.qrcode:
        return 'qrcode';
      case CameraType.documents:
        return 'documents';
      case CameraType.admin:
        return 'admin';
      case CameraType.gcndn:
        return 'gcndn';
      case CameraType.cccd:
        return 'cccd';
      case CameraType.cccdChip:
        return 'cccd_chip';
      case CameraType.gplx:
        return 'gplx';
      case CameraType.dangKyXeMaySau2015:
        return 'dang_ky_xe_may_sau_2015';
      case CameraType.dangKyOtoXeMaySau2021:
        return 'dang_ky_oto_xe_may_sau_2021';
      case CameraType.dangKiem:
        return 'dang_kiem';
      case CameraType.hoChieu:
        return 'ho_chieu';
      case CameraType.hoaDonBan:
        return 'hoa_don_ban';
      default:
        return 'documents';
    }
  }
}
