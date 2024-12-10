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
        return "http://localhost:4000/api/";
      case Environment.stg:
        //TODO update when build stg
        return "http://stg";
      case Environment.prod:
        //TODO update when build prod
        return "http://192.11.4.103:4000/api/";
    }
  }
}
