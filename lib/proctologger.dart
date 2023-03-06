library proctologger;

import 'dart:developer';

import '../../core/utils/util.dart';
import '../../domain/entities/entity_log_parameter.dart';
import '../../logic/states/state_channel.dart';
import '../../logic/states/state_type.dart';
import 'data/class/class_log_template.dart';

class Logger {
  /* -------------------------------------------------------------------------- */
  /*                                  Variables                                 */
  /* -------------------------------------------------------------------------- */
  final LoggerParameters parameters;
  /* -------------------------------------------------------------------------- */
  /*                                 Constructor                                */
  /* -------------------------------------------------------------------------- */
  Logger({
    this.parameters = const LoggerParameters(),
  }) {
    init();
  }
  /* -------------------------------------------------------------------------- */
  /*                              Public functions                              */
  /* -------------------------------------------------------------------------- */
  void init() {
    if (parameters.showLog == true && parameters.showInitMessage == true) {
      LoggerTemplate(parameters).createInitTitle();
      log("");
      LoggerTemplate(parameters).createInitDescription();
      log("");
    }
  }

  /// Logs an information message to the console.
  ///
  /// If [parameters.showLog] is true and the [parameters.filterTypes] list
  /// contains [LoggerTypeState.info] or is empty, and the [parameters.filterTags]
  /// list contains at least one tag in the [tags] list or is empty, then the
  /// message is logged.
  ///
  /// The log message is generated using the [LoggerTemplate] class and includes
  /// the message, optional [channel], and [tags]. The stack trace is also included
  /// in the log message.
  void info(String message,
      {LoggerChannelState? channel, List<String> tags = const []}) {
    if (parameters.showLog == true) {
      if (parameters.filterTypes.contains(LoggerTypeState.info) ||
          parameters.filterTypes.isEmpty) {
        if (LoggerUtil().haveCommonWords(parameters.filterTags, tags) ||
            parameters.filterTags.isEmpty) {
          StackTrace stackTrace = StackTrace.current;
          LoggerTemplate(parameters).templateBox(
              type: LoggerTypeState.info,
              channel: channel,
              message: message,
              stack: stackTrace,
              tags: tags);
        }
      }
    }
  }

  /// Logs a warning message to the console.
  ///
  /// If [parameters.showLog] is true and the [parameters.filterTypes] list
  /// contains [LoggerTypeState.info] or is empty, and the [parameters.filterTags]
  /// list contains at least one tag in the [tags] list or is empty, then the
  /// message is logged.
  ///
  /// The log message is generated using the [LoggerTemplate] class and includes
  /// the message, optional [channel], and [tags]. The stack trace is also included
  /// in the log message.
  void warning(String message,
      {LoggerChannelState? channel, List<String> tags = const []}) {
    if (parameters.showLog == true) {
      if (parameters.filterTypes.contains(LoggerTypeState.warning) ||
          parameters.filterTypes.isEmpty) {
        if (LoggerUtil().haveCommonWords(parameters.filterTags, tags) ||
            parameters.filterTags.isEmpty) {
          StackTrace stackTrace = StackTrace.current;
          LoggerTemplate(parameters).templateBox(
              type: LoggerTypeState.warning,
              channel: channel,
              message: message,
              stack: stackTrace,
              tags: tags);
        }
      }
    }
  }

  /// Logs an error message to the console.
  ///
  /// If [parameters.showLog] is true and the [parameters.filterTypes] list
  /// contains [LoggerTypeState.info] or is empty, and the [parameters.filterTags]
  /// list contains at least one tag in the [tags] list or is empty, then the
  /// message is logged.
  ///
  /// The log message is generated using the [LoggerTemplate] class and includes
  /// the message, optional [channel], and [tags]. The stack trace is also included
  /// in the log message.
  void error(String message,
      {LoggerChannelState? channel, List<String> tags = const []}) {
    if (parameters.showLog == true) {
      if (parameters.filterTypes.contains(LoggerTypeState.error) ||
          parameters.filterTypes.isEmpty) {
        if (LoggerUtil().haveCommonWords(parameters.filterTags, tags) ||
            parameters.filterTags.isEmpty) {
          StackTrace stackTrace = StackTrace.current;
          LoggerTemplate(parameters).templateBox(
              type: LoggerTypeState.error,
              channel: channel,
              message: message,
              stack: stackTrace,
              tags: tags);
        }
      }
    }
  }

  /// Logs a database message to the console.
  ///
  /// If [parameters.showLog] is true and the [parameters.filterTypes] list
  /// contains [LoggerTypeState.info] or is empty, and the [parameters.filterTags]
  /// list contains at least one tag in the [tags] list or is empty, then the
  /// message is logged.
  ///
  /// The log message is generated using the [LoggerTemplate] class and includes
  /// the message, optional [channel], and [tags]. The stack trace is also included
  /// in the log message.
  void database(String message,
      {LoggerChannelState? channel, List<String> tags = const []}) {
    if (parameters.showLog == true) {
      if (parameters.filterTypes.contains(LoggerTypeState.database) ||
          parameters.filterTypes.isEmpty) {
        if (LoggerUtil().haveCommonWords(parameters.filterTags, tags) ||
            parameters.filterTags.isEmpty) {
          StackTrace stackTrace = StackTrace.current;
          LoggerTemplate(parameters).templateBox(
              type: LoggerTypeState.database,
              channel: channel,
              message: message,
              stack: stackTrace,
              tags: tags);
        }
      }
    }
  }

  /// Prints a debug log message with a box template including a header, timestamp, description, and footer.
  ///
  /// The [object] argument is required and contains the data to be logged.
  /// The [channel] argument is optional and specifies the scope of the log message.
  /// The [message] argument is optional and contains a description of the logged data.
  ///
  /// If the global filter configuration for log types or tags matches the current log message, the message will be printed.
  ///
  /// The log message will include a header with the log type and channel, a timestamp, the description message, and a footer with the source file and line number.
  void debug(
    dynamic object, {
    LoggerChannelState? channel,
    String? message,
  }) {
    if (parameters.showLog == true) {
      if (parameters.filterTypes.contains(LoggerTypeState.debug) ||
          parameters.filterTypes.isEmpty) {
        if ((parameters.filterTags.isNotEmpty &&
                parameters.filterTypes.contains(LoggerTypeState.debug)) ||
            parameters.filterTags.isEmpty) {
          StackTrace stackTrace = StackTrace.current;
          LoggerTemplate(parameters).templateDebug(
              type: LoggerTypeState.debug,
              channel: channel,
              message: message,
              object: object,
              stack: stackTrace);
        }
      }
    }
  }

  /// Logs an action message to the console.
  ///
  /// If [parameters.showLog] is true and the [parameters.filterTypes] list
  /// contains [LoggerTypeState.info] or is empty, and the [parameters.filterTags]
  /// list contains at least one tag in the [tags] list or is empty, then the
  /// message is logged.
  ///
  /// The log message is generated using the [LoggerTemplate] class and includes
  /// the message, optional [channel], and [tags]. The stack trace is also included
  /// in the log message.
  void action(String message,
      {LoggerChannelState? channel, List<String> tags = const []}) {
    if (parameters.showLog == true) {
      if (parameters.filterTypes.contains(LoggerTypeState.action) ||
          parameters.filterTypes.isEmpty) {
        if (LoggerUtil().haveCommonWords(parameters.filterTags, tags) ||
            parameters.filterTags.isEmpty) {
          StackTrace stackTrace = StackTrace.current;
          LoggerTemplate(parameters).templateBox(
              type: LoggerTypeState.action,
              channel: channel,
              message: message,
              stack: stackTrace,
              tags: tags);
        }
      }
    }
  }
}
