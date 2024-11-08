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
        return "http://123.25.30.96:31815";
      case Environment.stg:
        //TODO update when build stg
        return "http://stg";
      case Environment.prod:
        //TODO update when build prod
        return "http://prod";
    }
  }

  String get sendBirdApp {
    switch (this) {
      case Environment.dev:
        return '1B759A88-0B38-432E-9EFF-8732B233AF1A';
      case Environment.stg:
        //TODO update when build stg
        return '1B759A88-0B38-432E-9EFF-8732B233AF1A';
      case Environment.prod:
        //TODO update when build prod
        return '1B759A88-0B38-432E-9EFF-8732B233AF1A';
    }
  }
}
