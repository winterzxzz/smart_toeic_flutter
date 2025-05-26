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
        return "https://7478-2a09-bac5-d45a-2646-00-3d0-4a.ngrok-free.app/api";
      case Environment.stg:
        return "http://stg";
      case Environment.prod:
        return "https://7478-2a09-bac5-d45a-2646-00-3d0-4a.ngrok-free.app/api";
    }
  }
}
