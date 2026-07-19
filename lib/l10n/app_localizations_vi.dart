// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Hủy';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get noData => 'Không có dữ liệu';

  @override
  String get offline => 'Thiết bị đang ngoại tuyến';

  @override
  String get unexpectedErrorOccurred => 'Đã xảy ra lỗi không mong muốn';

  @override
  String get menuCounter => 'Đếm';

  @override
  String get menuApi => 'API';

  @override
  String get menuSetting => 'Cài đặt';

  @override
  String get counterDescription =>
      'Demo trạng thái Riverpod. Nhấn nút để cập nhật số đếm.';

  @override
  String get counterIncrement => 'Tăng';

  @override
  String get counterDecrement => 'Giảm';

  @override
  String get counterReset => 'Đặt lại';

  @override
  String get apiExampleDescription =>
      'Ví dụ Dio + Repository + ViewModel (JSONPlaceholder /posts).';

  @override
  String get preferences => 'Tuỳ chọn';

  @override
  String get appearances => 'Giao diện';

  @override
  String get auto => 'Theo hệ thống';

  @override
  String get lightMode => 'Sáng';

  @override
  String get darkMode => 'Tối';

  @override
  String get language => 'Ngôn ngữ';
}
