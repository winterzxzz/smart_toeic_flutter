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
        return "https://9533ff5e30a0.ngrok-free.app/api";
      case Environment.stg:
        return "https://9533ff5e30a0.ngrok-free.app/api";
      case Environment.prod:
        return "https://9533ff5e30a0.ngrok-free.app/api";
    }
  }

  String get bannerAdUnitId {
    switch (this) {
      case Environment.dev:
        return "ca-app-pub-4829406909435995/9509723114";
      case Environment.stg:
        return "ca-app-pub-4829406909435995/9509723114";
      case Environment.prod:
        return "ca-app-pub-4829406909435995/9509723114";
    }
  }

  String get testAdUnitId {
    switch (this) {
      case Environment.dev:
        return "ca-app-pub-3940256099942544/6300978111";
      case Environment.stg:
        return "ca-app-pub-3940256099942544/6300978111";
      case Environment.prod:
        return "ca-app-pub-3940256099942544/6300978111";
    }
  }
}
