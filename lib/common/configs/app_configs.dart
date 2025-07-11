import '../../data/models/enums/language.dart';
import 'app_env_config.dart';

class AppConfigs {
  AppConfigs._();
  static const String appName = "Smart TOEIC Prep";
  static Environment env = Environment.dev;

  ///API Env
  static String get baseUrl => env.baseUrl;
  static String get bannerAdUnitId => env.bannerAdUnitId;
  static String get testAdUnitId => env.testAdUnitId;
  static String get mocKyBaseUrl => 'https://run.mocky.io';
  static String get envName => env.envName;

  ///DateFormat
  static const dateDisplayFormat = 'dd/MM/yyyy';
  static const dateTimeDisplayFormat = 'dd/MM/yyyy HH:mm';

  ///Paging
  static const pageSize = 10;
  static const pageSizeMax = 1000;

  ///Local
  static const defaultLanguage = Language.english;

  static const dateTimeAPIFormat =
      "YYYY-MM-DDThh:mm:ssTZD"; //Use DateTime.parse(date) instead of ...
  static const dateAPIFormat = 'dd/MM/yyyy';

  ///Date range
  static final identityMinDate = DateTime(1900, 1, 1);
  static final identityMaxDate = DateTime.now();
  static final birthMinDate = DateTime(1900, 1, 1);
  static final birthMaxDate = DateTime.now();

  ///Font
  static const fontFamily = 'Roboto';

  ///Max file
  static const maxAttachFile = 5;

  static const scrollThreshold = 500.0;

  // mail to
  static const mailTo = 'winter@toeic.com';
}

class DatabaseConfig {
  static const int version = 1;
}
