import 'package:proctologger/logic/states/state_channel.dart';
import 'package:proctologger/proctologger.dart';

var logger = Logger();

void main() {
  print(
      'Run with either `dart example/main.dart` or `dart --enable-asserts example/main.dart`.');
  demo();
}

void demo() {
  logger.info(
    "This is an info message",
  );
  logger.info(
    "Here is a very long information message to demonstrate multi-line handling and tags",
  );
  logger.warning(
    "This is a warning message",
  );
  logger.action(
    "This is an action message",
  );
  logger.database(
    "This is a database message",
  );
  logger.error(
    "This is an error message",
  );
  logger.debug("This is a variable to debug");
  logger.info(
    "This is an info message",
    channel: LoggerChannelState.app,
    tags: ["tag", "Another tag"]
  );
  logger.debug(
    logger.parameters,
    channel: LoggerChannelState.app,
    message: "Debugging variable @parameters",
  );
}