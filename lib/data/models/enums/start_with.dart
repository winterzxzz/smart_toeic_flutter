enum StartWith { home, myFiles }

extension StartWithExt on StartWith {
  String get name {
    switch (this) {
      case StartWith.home:
        return 'Home';
      case StartWith.myFiles:
        return 'My files';
    }
  }

  int get index {
    switch (this) {
      case StartWith.home:
        return 0;
      case StartWith.myFiles:
        return 1;
      default:
        return 0;
    }
  }
}
