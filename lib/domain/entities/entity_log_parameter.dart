import '../../logic/states/state_type.dart';

class LoggerParameters {
  final int maxLength;
  final String dateFormat;
  final bool showLog;
  final bool showInitMessage;
  final List<LoggerTypeState> filterTypes;
  final List<String> filterTags;

  const LoggerParameters({
    this.maxLength = 54,
    this.dateFormat = "HH:mm:ss:SSS",
    this.showLog = true,
    this.showInitMessage = true,
    this.filterTypes = const [],
    this.filterTags = const [],
  }) : assert(maxLength >= 35);

  Map<String, dynamic> toJson() => {
        "maxLength": maxLength,
        "dateFormat": dateFormat,
        "showLog": showLog,
        "showInitMessage": showInitMessage,
        "filterType": "$filterTypes",
        "filterTags": "$filterTags",
      };
}
