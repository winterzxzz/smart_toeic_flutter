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
        return "https://8abe-2a09-bac1-7aa0-50-00-3d0-6b.ngrok-free.app/api";
      case Environment.stg:
        return "http://stg";
      case Environment.prod:
        return "https://8abe-2a09-bac1-7aa0-50-00-3d0-6b.ngrok-free.app/api";
    }
  }
}
