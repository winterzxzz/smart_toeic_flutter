enum Environment {
  dev,
  stg,
  prod,
}

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
        return "https://28cc-2a09-bac1-7aa0-50-00-3cf-1.ngrok-free.app/api";
      case Environment.stg:
        //TODO update when build stg
        return "http://stg";
      case Environment.prod:
        //TODO update when build prod
        return "https://c8e0-1-55-211-216.ngrok-free.app/api";
    }
  }
}
