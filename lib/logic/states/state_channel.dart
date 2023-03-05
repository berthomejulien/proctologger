
enum LoggerChannelState {
  app,
  security,
  request,
}

extension LoggerChannelStateUtils on LoggerChannelState {
  String get name {
    switch (this) {
      case LoggerChannelState.app:
        return "app";
      case LoggerChannelState.security:
        return "security";
      case LoggerChannelState.request:
        return "request";
    }
  }
}


