enum Environment { dev, stg, prod }

extension EnvironmentExt on Environment {
  String get envName {
    switch (this) {
      case Environment.dev:
        return 'DEV';
      case Environment.stg:
        return 'STG';
      case Environment.prod:
        return 'PROD';
    }
  }

  String get baseUrl {
    switch (this) {
      case Environment.dev:
        return "https://f12f-58-186-129-70.ngrok-free.app/api";
      case Environment.stg:
        return "http://stg";
      case Environment.prod:
        return "https://f12f-58-186-129-70.ngrok-free.app/api";
    }
  }
}
