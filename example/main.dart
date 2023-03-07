import 'package:proctologger/logic/states/state_channel.dart';
import 'package:proctologger/proctologger.dart';

// You can use a helper to initialize the logger only once throughout your application
// and apply the logger's parameters everywhere, for example.
class LoggerHelper {

  static final LoggerHelper _singleton = LoggerHelper._internal();
  final Logger logger = Logger(); // => Here, you can apply your custom parameters.

  factory LoggerHelper() {
    return _singleton;
  }

  LoggerHelper._internal();
}

void main() {
  demo();
}

void demo() {
  LoggerHelper().logger.info(
    "This is an info message",
  );
  LoggerHelper().logger.info(
    "Here is a very long information message to demonstrate multi-line handling and tags",
  );
  LoggerHelper().logger.warning(
    "This is a warning message",
  );
  LoggerHelper().logger.action(
    "This is an action message",
  );
  LoggerHelper().logger.database(
    "This is a database message",
  );
  LoggerHelper().logger.error(
    "This is an error message",
  );
  LoggerHelper().logger.debug("This is a variable to debug");
  LoggerHelper().logger.info(
    "This is an info message",
    channel: LoggerChannelState.app,
    tags: ["tag", "Another tag"]
  );
  LoggerHelper().logger.debug(
    LoggerHelper().logger.parameters,
    channel: LoggerChannelState.app,
    message: "Debugging variable @parameters",
  );
}