import 'state_ansi_color.dart';

enum LoggerTypeState {
  info,
  warning,
  error,
  debug,
  database,
  action,
}

extension LoggerTypeStateUtils on LoggerTypeState {
  String get color {
    switch (this) {
      case LoggerTypeState.info:
        return LoggerAnsiColors.blue.color;
      case LoggerTypeState.warning:
        return LoggerAnsiColors.yellow.color;
      case LoggerTypeState.error:
        return LoggerAnsiColors.red.color;
      case LoggerTypeState.debug:
        return LoggerAnsiColors.white.color;
      case LoggerTypeState.database:
        return LoggerAnsiColors.purple.color;
      case LoggerTypeState.action:
        return LoggerAnsiColors.cyan.color;
    }
  }

  String get name {
    switch (this) {
      case LoggerTypeState.info:
        return "INFO";
      case LoggerTypeState.warning:
        return "WARNING";
      case LoggerTypeState.error:
        return "ERROR";
      case LoggerTypeState.debug:
        return "DEBUG";
      case LoggerTypeState.database:
        return "DATABASE";
      case LoggerTypeState.action:
        return "ACTION";
    }
  }
}
