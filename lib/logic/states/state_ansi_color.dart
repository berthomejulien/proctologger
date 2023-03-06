enum LoggerAnsiColors {
  reset,
  black,
  white,
  red,
  green,
  yellow,
  blue,
  cyan,
  purple
}

extension LoggerAnsiColorsUtils on LoggerAnsiColors {
  String get color {
    switch (this) {
      case LoggerAnsiColors.reset:
        return "\x1B[0m";
      case LoggerAnsiColors.black:
        return "\x1B[30m";
      case LoggerAnsiColors.white:
        return "\x1B[37m";
      case LoggerAnsiColors.red:
        return "\x1B[31m";
      case LoggerAnsiColors.green:
        return "\x1B[32m";
      case LoggerAnsiColors.yellow:
        return "\x1B[33m";
      case LoggerAnsiColors.blue:
        return "\x1B[34m";
      case LoggerAnsiColors.cyan:
        return "\x1B[36m";
      case LoggerAnsiColors.purple:
        return "\x1B[35m";
    }
  }
}
