import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/constant.dart';
import '../../domain/entities/entity_log_parameter.dart';
import '../../logic/states/state_align_text.dart';
import '../../logic/states/state_ansi_color.dart';
import '../../logic/states/state_channel.dart';
import '../../logic/states/state_type.dart';
import 'class_stack_trace_parser.dart';

class LoggerTemplate {
  /* -------------------------------------------------------------------------- */
  /*                                  Variables                                 */
  /* -------------------------------------------------------------------------- */
  final LoggerParameters parameters;
  /* -------------------------------------------------------------------------- */
  /*                                 Constructor                                */
  /* -------------------------------------------------------------------------- */
  LoggerTemplate(this.parameters);
  /* -------------------------------------------------------------------------- */
  /*                              Public functions                              */
  /* -------------------------------------------------------------------------- */
  /// Creates a log box with a header, body message, and footer.
  ///
  /// This function takes a required [type] parameter that defines the type of log message
  /// (debug, info, warning, or error), a [channel] parameter that specifies the channel
  /// on which the message is sent (if applicable), a required [message] parameter that contains
  /// the text of the message, a [stack] parameter that contains the stack trace for the message,
  /// and an optional [tags] parameter that contains tags to be included in the log message.
  ///
  /// If [tags] is not null and not empty, each tag is converted to title case and added to the beginning
  /// of the log message in square brackets. The message is then appended after the tags. If [tags] is null
  /// or empty, the [message] parameter is used as the log message without any tags.
  ///
  /// The [message] parameter is checked for its length, and if it exceeds the maximum character count,
  /// it is split into multiple lines while retaining whole words.
  ///
  /// The log box consists of a header, the message body (possibly spanning multiple lines),
  /// and a footer that contains the filename and line number of the code that generated the log.
  ///
  /// Example:
  ///
  /// ```dart
  /// final type = LoggerTypeState.info;
  /// final channel = LoggerChannelState.http;
  /// final message = 'HTTP response received';
  /// final stack = StackTrace.current;
  /// final tags = ['networking', 'response'];
  ///
  /// templateBox(type: type, channel: channel, message: message, stack: stack, tags: tags);
  /// ```
  void templateBox(
      {required LoggerTypeState type,
      LoggerChannelState? channel,
      required String message,
      required StackTrace stack,
      List<String>? tags}) {
    _boxHeader(type: type, channel: channel);

    String bodyMessage = "";

    if (tags != null && tags.isNotEmpty) {
      List<String> convertInTagFormat = tags
          .map((tag) =>
              "[${tag[0].toUpperCase()}${tag.substring(1).toLowerCase()}]")
          .toList();
      for (var tag in convertInTagFormat) {
        bodyMessage += tag;
      }
      bodyMessage += " - $message";
    } else {
      bodyMessage = message;
    }

    List<String> lengthSplitterObject =
        splitObjectIfTooLong(object: bodyMessage);
    _templateTextMultiLines(textList: lengthSplitterObject);

    _boxFooter(stack: stack);
  }

  /// Creates a log box with debug information, including the type and value of an object,
  /// and a message (if provided).
  ///
  /// This function takes a required [type] parameter that specifies the type of debug information,
  /// a [channel] parameter that specifies the channel on which the message is sent (if applicable),
  /// an optional [message] parameter that contains the text of the message, a required [object] parameter
  /// that is the object whose type and value will be logged, and a [stack] parameter that contains
  /// the stack trace for the debug message.
  ///
  /// If the [message] parameter is not null, it is added to the log box with a "Message:" label. The [object]
  /// parameter is then checked for its type and value, and both are added to the log box with a "Type:" and "Value:"
  /// label respectively. If the value of the [object] parameter is too long to fit in a single line, it is split
  /// into multiple lines while retaining whole words.
  ///
  /// The log box consists of a header, the debug information (possibly spanning multiple lines), and a footer
  /// that contains the filename and line number of the code that generated the log.
  ///
  /// Example:
  ///
  /// ```dart
  /// final type = LoggerTypeState.debug;
  /// final channel = LoggerChannelState.database;
  /// final message = 'Failed to open database';
  /// final object = DatabaseException('Failed to open database');
  /// final stack = StackTrace.current;
  ///
  /// templateDebug(type: type, channel: channel, message: message, object: object, stack: stack);
  /// ```
  void templateDebug(
      {required LoggerTypeState type,
      LoggerChannelState? channel,
      String? message,
      required dynamic object,
      required StackTrace stack}) {
    _boxHeader(type: type, channel: channel);

    if (message != null) {
      List<String> lengthSplitterObject = splitObjectIfTooLong(
          object: message.toString(), subMessage: "Message: ");
      _templateTextMultiLines(
          textList: lengthSplitterObject, subMessage: "Message: ");
    }
    List<String> lengthSplitterObject = splitObjectIfTooLong(
        object: object.runtimeType.toString(), subMessage: "Type: ");
    _templateTextMultiLines(
        textList: lengthSplitterObject, subMessage: "Type: ");

    List<String> lineSplitterObject = _splitObjectInMultiLines(object: object);
    if (lineSplitterObject.length > 1) {
      debugPrint(_lineText(
        primaryMessage: "Value: ",
      ));
      for (var i = 0; i < lineSplitterObject.length; i++) {
        List<String> lengthSplitterObject =
            splitObjectIfTooLong(object: lineSplitterObject[i]);
        _templateTextMultiLines(textList: lengthSplitterObject);
      }
    } else {
      _templateTextMultiLines(
          textList: lineSplitterObject, subMessage: "Value: ");
    }

    _boxFooter(stack: stack);
  }

  ///
  /// Adds fill characters to a string to match a maximum length, depending on the primary and secondary text and alignment.
  /// If the secondary text is not specified, it is set to an empty string.
  ///
  /// Throws an exception if the alignment is "between" and there is no secondary text.
  ///
  /// Returns a list of strings, where the first string is the filled space on the left side of the text, the second string
  /// is the filled space in the center, and the third string is the filled space on the right side of the text.
  ///
  List<String> addFillCaractere(
      {required String primaryText,
      String fill = ' ',
      String? secondaryText,
      LoggerAlignmentState? alignment}) {
    secondaryText ??= '';
    alignment ??= LoggerAlignmentState.left;

    // Error if there is no secondary text in between alignment
    if (alignment == LoggerAlignmentState.between && secondaryText.isEmpty) {
      throw Exception("You must enter a secondary message !");
    }

    final fillCount =
        parameters.maxLength - primaryText.length - secondaryText.length;

    List<String> spaceLeft = [];
    List<String> spaceRight = [];
    List<String> spaceCenter = [];

    if (alignment == LoggerAlignmentState.center) {
      spaceLeft = List.filled(fillCount ~/ 2, fill);
      spaceRight = List.filled(fillCount - spaceLeft.length, fill);
    } else if (alignment == LoggerAlignmentState.left) {
      if (primaryText.isNotEmpty) {
        spaceLeft = [" "];
      }
      spaceRight =
          List.filled(fillCount - spaceLeft.length - spaceCenter.length, fill);
    } else if (alignment == LoggerAlignmentState.right) {
      if (primaryText.isNotEmpty) {
        spaceRight = [" "];
        spaceCenter = [" "];
      }
      spaceLeft =
          List.filled(fillCount - spaceCenter.length - spaceRight.length, fill);
    } else if (alignment == LoggerAlignmentState.between) {
      spaceLeft = [" "];
      spaceRight = [" "];
      spaceCenter =
          List.filled(fillCount - spaceLeft.length - spaceRight.length, fill);
    }

    return [spaceLeft.join(), spaceCenter.join(), spaceRight.join()];
  }

  /// Builds a line structure with the specified spaces and text, and optional primary and secondary colors.
  ///
  /// The spaceLeft, spaceCenter, and spaceRight arguments are strings representing the spaces to add to the left, center,
  /// and right of the text, respectively.
  ///
  /// The primaryText argument is the primary message to display, and primaryColor is the optional color of the primary message.
  ///
  /// The secondaryText argument is the secondary message to display, and secondaryColor is the optional color of the secondary message.
  ///
  /// Returns the concatenated string with the specified spaces and text, and optional primary and secondary colors.
  String lineStructure({
    required String spaceLeft,
    required String spaceCenter,
    required String spaceRight,
    String primaryText = '',
    String? primaryColor = '',
    String? secondaryText = '',
    String? secondaryColor = '',
  }) {
    return spaceLeft +
        primaryColor! +
        primaryText +
        LoggerAnsiColors.reset.color +
        spaceCenter +
        secondaryColor! +
        secondaryText! +
        LoggerAnsiColors.reset.color +
        spaceRight;
  }

  /// Creates a formatted line with primary and/or secondary messages and colors,
  /// aligned based on the specified alignment. The line is filled with the specified
  /// character between the messages and the left/right sides of the line.
  ///
  /// Required parameters:
  ///   - primaryMessage: the primary message to display on the line.
  ///
  /// Optional parameters:
  ///   - primaryColor: the color for the primary message, as an ANSI escape code.
  ///   - secondaryMessage: the secondary message to display on the line.
  ///   - secondaryColor: the color for the secondary message, as an ANSI escape code.
  ///   - alignment: the alignment for the messages on the line (default is left).
  ///   - fill: the character to fill the line with (default is a space).
  ///
  /// Returns:
  ///   A formatted string with the specified messages, colors, alignment, and fill.
  String createLine(
      {required String primaryMessage,
      String primaryColor = "",
      String secondaryMessage = "",
      String secondaryColor = "",
      LoggerAlignmentState? alignment,
      String fill = ' '}) {
    List<String> spaces = addFillCaractere(
        primaryText: primaryMessage,
        fill: fill,
        secondaryText: secondaryMessage,
        alignment: alignment);
    return lineStructure(
      spaceLeft: spaces[0],
      spaceCenter: spaces[1],
      spaceRight: spaces[2],
      primaryText: primaryMessage,
      primaryColor: primaryColor,
      secondaryText: secondaryMessage,
      secondaryColor: secondaryColor,
    );
  }

  /// Prints a fancy ASCII art title with centered alignment
  void createInitTitle() {
    List<String> title = [
      "______               _          ",
      "| ___ \\             | |         ",
      "| |_/ / __ ___   ___| |_ ___    ",
      "|  __/ '__/ _ \\ / __| __/ _ \\   ",
      "| |  | | | (_) | (__| || (_) |  ",
      "\\_|  |_|  \\___/ \\___|\\__\\___/   ",
      "| |                             ",
      "| | ___   __ _  __ _  ___ _ __  ",
      "| |/ _ \\ / _` |/ _` |/ _ \\ '__| ",
      "| | (_) | (_| | (_| |  __/ |    ",
      "|_|\\___/ \\__, |\\__, |\\___|_|    ",
      "          __/ | __/ |           ",
      "         |___/ |___/            ",
    ];
    for (var line in title) {
      debugPrint(createLine(
          primaryMessage: line, alignment: LoggerAlignmentState.center));
    }
  }

  /// Prints the initial description of the logger box with centered alignment.
  void createInitDescription() {
    List<String> lengthSplitterObject = splitObjectIfTooLong(
        object:
            "Welcome to Proctologger, the Flutter logger that will help you dig deep into your code!");
    for (var i = 0; i < lengthSplitterObject.length; i++) {
      debugPrint(createLine(
          primaryMessage: lengthSplitterObject[i],
          fill: ' ',
          alignment: LoggerAlignmentState.center));
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                              Private functions                             */
  /* -------------------------------------------------------------------------- */
  /// Returns a line of text used as a header for a log message.
  ///
  /// The line consists of a corner up-left symbol, followed by a series of
  /// horizontal lines, and ending with a corner up-right symbol. The length of the
  /// line is defined by the `createLine` function, which uses the maximum length
  /// specified in the `parameters` class.
  ///
  /// Example:
  /// ```
  /// ╭───────────────────────────────────────────────────────╮
  /// ```
  ///
  /// Returns the header line as a string.
  String _lineHeader() {
    String line = LoggerConstant.kTemplateCornerUpLeft;
    line += createLine(
        primaryMessage: '', fill: LoggerConstant.kTemplateBorderMainHorizontal);
    line += LoggerConstant.kTemplateCornerUpRight;
    return line;
  }

  /// Returns a separator line using the default separator template.
  ///
  /// The separator line is built using the `createLine` function with an empty
  /// primary message and the `kTemplateBorderSeparator` fill character.
  ///
  /// Returns a string representing the separator line.
  String _lineSeparator() {
    String line = LoggerConstant.kTemplateBorderSeparatorLeft;
    line += createLine(
        primaryMessage: '', fill: LoggerConstant.kTemplateBorderSeparator);
    line += LoggerConstant.kTemplateBorderSeparatorRight;
    return line;
  }

  /// Returns a string representing a text line in the logger box.
  ///
  /// The line will be composed of three parts: a left border, the primary text
  /// with an optional secondary text, and a right border. The primary and
  /// secondary texts can be colored using ANSI escape codes by passing the
  /// corresponding strings in `primaryColor` and `secondaryColor` parameters.
  ///
  /// An optional `alignment` parameter can be used to align the primary and
  /// secondary texts inside the line. The default is left alignment.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// _lineText(
  ///   primaryMessage: 'Hello, world!',
  ///   primaryColor: LoggerAnsiColors.green.color,
  ///   secondaryMessage: 'This is a secondary message.',
  ///   secondaryColor: LoggerAnsiColors.yellow.color,
  ///   alignment: LoggerAlignmentState.center
  /// );
  /// ```
  String _lineText(
      {required String primaryMessage,
      String primaryColor = "",
      String secondaryMessage = "",
      String secondaryColor = "",
      LoggerAlignmentState? alignment}) {
    String line = LoggerConstant.kTemplateBorderMainVertical;
    line += createLine(
        primaryMessage: primaryMessage,
        primaryColor: primaryColor,
        secondaryMessage: secondaryMessage,
        secondaryColor: secondaryColor,
        alignment: alignment);
    line += LoggerConstant.kTemplateBorderMainVertical;
    return line;
  }

  /// Returns a string representing the footer of a log line, using the template defined in LoggerConstant.
  ///
  /// The footer consists of a left corner symbol, a horizontal line, and a right corner symbol,
  /// all defined in LoggerConstant. This function uses the [createLine] function to create the
  /// horizontal line part of the footer, passing an empty primary message and using the main
  /// horizontal template border character defined in LoggerConstant as fill. The resulting
  /// string is then concatenated with the corner symbols, and returned as the footer.
  ///
  /// Example:
  ///
  /// Logger._lineFooter();
  ///
  /// Returns:
  ///
  /// ╚════════════════════════════════════════════════════════════════════════════╝
  String _lineFooter() {
    String line = LoggerConstant.kTemplateCornerDownLeft;
    line += createLine(
        primaryMessage: '', fill: LoggerConstant.kTemplateBorderMainHorizontal);
    line += LoggerConstant.kTemplateCornerDownRight;
    return line;
  }

  /// Prints a box header with the specified logger type and channel.
  ///
  /// The box header consists of a border made up of the following characters:
  /// ┏ ━ ┓
  /// ┃ ┃
  /// ┗ ━ ┛
  ///
  /// The logger type is displayed on the left side of the header, while the logger
  /// channel (if specified) is displayed on the right side, separated by a bullet
  /// character.
  ///
  /// Below the header, a text line is displayed with the logger type and channel
  /// names in color, along with the current date and time formatted according to
  /// the date format specified in the [LoggerParameters] object.
  ///
  /// Finally, a separator line is printed to visually separate the header from
  /// the rest of the log messages.
  ///
  /// Throws a [FormatException] if the date format specified in the [LoggerParameters]
  /// object is invalid.
  ///
  void _boxHeader({
    required LoggerTypeState type,
    LoggerChannelState? channel,
  }) {
    debugPrint(LoggerTemplate(parameters)._lineHeader());

    String headerMessage = type.name;
    if (channel != null) {
      headerMessage += " • ${channel.name}";
    }

    var date = DateTime.now();
    var creationDate = DateFormat(parameters.dateFormat).format(date);
    debugPrint(LoggerTemplate(parameters)._lineText(
        primaryMessage: headerMessage,
        primaryColor: type.color,
        secondaryMessage: creationDate,
        alignment: LoggerAlignmentState.between));
    debugPrint(LoggerTemplate(parameters)._lineSeparator());
  }

  /// Private method that prints the footer of a logger box with the file name and line number of the caller.
  ///
  /// The method takes in a required [stack] of type [StackTrace] that is used to extract the file name
  /// and line number of the caller. It then prints out the file name and line number as the primary message
  /// aligned to the right of the logger box footer, using [_lineText] function. Finally, it prints the logger
  /// box footer using [_lineFooter] function.
  void _boxFooter({required StackTrace stack}) {
    StackTraceParser stackTraceParser = StackTraceParser(stack);
    debugPrint(LoggerTemplate(parameters)._lineText(
        primaryMessage:
            "${stackTraceParser.fileName}:${stackTraceParser.lineNumber}",
        alignment: LoggerAlignmentState.right));
    debugPrint(LoggerTemplate(parameters)._lineFooter());
  }

  /// Prints the list of strings on separate lines using _lineText template.
  ///
  /// If [subMessage] is not empty, it is printed using a secondary color and is
  /// displayed above the first line of text. Each line of text is printed using
  /// a primary color and displayed on a separate line.
  ///
  /// Examples:
  ///
  ///  _templateTextMultiLines(textList: ["Hello, world!"]);
  ///  _templateTextMultiLines(textList: ["Hello", "World"], subMessage: "Greetings:");
  /// The first example prints the message "Hello, world!" using the default
  /// color. The second example prints the messages "Hello" and "World" on separate
  /// lines, with the sub-message "Greetings:" displayed above the first line of
  /// text.
  ///
  /// Throws an exception if [textList] is null or empty.
  void _templateTextMultiLines(
      {required List<String> textList, String subMessage = ""}) {
    for (var i = 0; i < textList.length; i++) {
      if (i == 0 && subMessage.isNotEmpty) {
        debugPrint(_lineText(
            primaryMessage: subMessage,
            secondaryMessage: textList[i],
            secondaryColor: LoggerAnsiColors.white.color));
      } else {
        debugPrint(_lineText(
            primaryMessage: textList[i],
            primaryColor: LoggerAnsiColors.white.color));
      }
    }
  }

  /// Splits a given object into multiple lines using [JsonEncoder] to convert it to
  /// JSON format, and then [LineSplitter] to split it into lines.
  ///
  /// Returns a [List] of [String], where each element represents a line of the JSON representation
  /// of the object.
  ///
  /// The object parameter is the object to split into lines.
  List<String> _splitObjectInMultiLines({required dynamic object}) {
    JsonEncoder pEncoder = const JsonEncoder.withIndent("  ");
    String pNewJson = pEncoder.convert(object);
    LineSplitter ls = const LineSplitter();
    return ls.convert(pNewJson);
  }

  /// Splits a given [object] into multiple lines of maximum [parameters.maxLength] characters,
  /// optionally adding a [subMessage] at the beginning of each line.
  ///
  /// Returns a list of strings, each representing a line of the split message.
  List<String> splitObjectIfTooLong(
      {required String object, String subMessage = ''}) {
    List<String> lines = [];
    // Create variable of object and subMessage
    String fullLine = "$subMessage$object";
    // Check if total length is too big and split the message in multi-line
    while (fullLine.length > parameters.maxLength - 2) {
      int lastSpace = fullLine.lastIndexOf(' ', parameters.maxLength - 2);
      // If the String message is just a big charactere length
      if (lastSpace == -1) {
        lastSpace = parameters.maxLength - 2;
      }
      lines.add(fullLine.substring(0, lastSpace));
      // Remove the first space on other lines when split
      if (fullLine.startsWith(" ")) {
        fullLine = fullLine.substring(lastSpace + 1);
      } else {
        fullLine = fullLine.substring(lastSpace);
      }
    }
    // Remove the first space on other lines when split
    if (fullLine.startsWith(" ")) {
      lines.add(fullLine.substring(1));
    } else {
      lines.add(fullLine);
    }
    // Remove subMessage
    lines[0] = lines[0].substring(subMessage.length);
    return lines;
  }
}
