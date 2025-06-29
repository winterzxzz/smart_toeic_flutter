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
        return "https://6c4b-42-114-121-174.ngrok-free.app/api";
      case Environment.stg:
        return "http://stg";
      case Environment.prod:
        return "https://6c4b-42-114-121-174.ngrok-free.app/api";
    }
  }

  String get adsBaseUrl {
    switch (this) {
      case Environment.dev:
        return "ca-app-pub-4829406909435995~8175610087";
      case Environment.stg:
        return "http://stg";
      case Environment.prod:
        return "ca-app-pub-4829406909435995~8175610087";
    }
  }
}
