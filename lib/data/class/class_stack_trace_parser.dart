class StackTraceParser {
  final StackTrace trace;
  late String function;
  late String path;
  late String fileName;
  late String lineNumber;

  StackTraceParser(this.trace) {
    _parseTrace();
  }

  /// Parses a stack trace to extract file, function name, and line number information.
  ///
  /// This function extracts the file, function name, and line number from a stack trace and assigns them to the
  /// corresponding class variables: [path], [fileName], [function], and [lineNumber].
  void _parseTrace() {
    var traceString = trace.toString().split("\n")[1];

    var regExpCodeLine = RegExp(r" (.*)");
    var indexOfFileName = traceString.indexOf(regExpCodeLine);
    //var r = regExpCodeLine.stringMatch(traceString);
    var fileInfo = traceString.substring(indexOfFileName);
    var listOfInfos = fileInfo.split(":");
    function = listOfInfos[0].toString();
    path = listOfInfos[1].toString();
    fileName = path.split("/").last;
    lineNumber = listOfInfos[2].toString();
  }
}
