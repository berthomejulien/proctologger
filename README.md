# **Proctologger** - logger for dart and flutter apps

<p align="center">
  <img src="https://raw.githubusercontent.com/berthomejulien/proctologger/main/assets/img/presentation.png"  width="600"/>
</p>

<br>

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT" />
  <img src="https://img.shields.io/github/languages/code-size/berthomejulien/proctologger.svg" alt="GitHub code size in bytes" />
  <img src="https://img.shields.io/github/stars/berthomejulien/proctologger?style=social.svg" alt="GitHub Repo stars" />
  <a href="https://www.buymeacoffee.com/berthomejulien" target="_blank"><img src="https://img.shields.io/badge/Buy%20me%20a%20coffee-donate-orange.svg" alt="Buy Me A Coffee"></a>
</p>

## Description

Welcome to Proctologger, the Flutter logger that will help you dig deep into your code! \
We promise that your debugging experience will be much more pleasant than at the doctor's!

Show some ❤️ and star the repo to support the project

## Resources

- [Pub Package](https://pub.dev/packages/proctologger)
- [Github repository](https://github.com/berthomejulien/proctologger)

## Get Started

Follow these steps:

### Add dependency

```yaml
dependencies:
  proctologger: ^1.1.0
```

### Easy to use

Just create an instance of ``Logger`` and start logging:

```dart
import 'package:proctologger/proctologger.dart';

Logger logger = Logger();

logger.info("This is an info message");
```

## Output

<div style="background-color:#192229; width: 100%;">
  <p ="left">
    <img src="https://raw.githubusercontent.com/berthomejulien/proctologger/main/assets/img/full_log.jpg"  width="600">
  </p>
</div>

## Documentation

### Options

When creating a logger, you can pass some options:

```dart
Logger logger = Logger(
    parameters: const LoggerParameters(
        // Width in the console.
        maxLength: 54, 
        // Change the date format.
        dateFormat: "HH:mm:ss:SSS", 
        // Show the logs in the console.
        showLog: true, 
        // Show the intialization message in the console.
        showInitMessage: true, 
        // Filter the log types.
        filterTypes: [], 
        // Filter the log tags.
        filterTags: []
    )
);
```

### Log type

Here are all the log types you can call:

```dart
logger.info("This is an info message");

logger.warning("This is a warning message");

logger.error("This is an error message");

logger.database("This is a database message");

logger.action("This is an action message");

logger.debug("This is a debug message");
```

### Log customization

Here are the parameters for all logs except `logger.debug()`.
You can call a `logger.info()` for example, and pass it optional parameters.

```dart
logger.info(
  "This is an info message",
  // This parameter is optional.
  // You can choose the channel with this LoggerChannelState class 
  // that has these options: app / security / request.
  channel: LoggerChannelState.app,
  // This parameter is optional.
  // You can enter tags if you want.
  tags: ["Tag", "Another tag"]
);
```

That gives you this:

<div style="background-color:#192229; width: 100%;">
  <p align="left">
    <img src="https://raw.githubusercontent.com/berthomejulien/proctologger/main/assets/img/log_info_tag.jpg"  width="600">
  </p>
</div>

When you can call a `logger.debug()` you can pass it optional parameters.\
You can directly debug ``String``, ``int``, ``num``, ``Map``, ``List``, and ``class`` objects.\
For example, I'm directly debugging the ``logger.parameters`` variable of the logger.

```dart
logger.debug(
  logger.parameters,
  // This parameter is optional.
  // You can choose the channel with this LoggerChannelState class 
  // that has these options: app / security / request.
  channel: LoggerChannelState.app,
  // This parameter is optional.
  // You can choose a message if you want
  message: "Debugging variable @parameters",
);
```

That gives you this:

<div style="background-color:#192229; width: 100%;">
  <p align="left">
    <img src="https://raw.githubusercontent.com/berthomejulien/proctologger/main/assets/img/log_debug.jpg"  width="600">
  </p>
</div>

### Filters

The ``filterTypes`` in ``logger.parameters`` decides which log types should be shown and which don't.
By default, all logs are displayed.\
For example, I only want to display ``info`` and ``debug`` logs:

```dart
Logger logger = Logger(
    parameters: const LoggerParameters(
        filterTypes: [LoggerTypeState.info, LoggerTypeState.debug], 
    )
);
```

The ``filterTags`` in ``logger.parameters`` decides which log tags should be shown and which don't.
By default, all logs are displayed.\
You can combine this parameter with ``FilterTypes`` for a more precise filter.\
For example, I only want to display logs that have the tags listed below:

```dart
Logger logger = Logger(
    parameters: const LoggerParameters(
        filterTags: ["Tags I want"], 
    )
);
```

## License

This project is under the `MIT` license - see the file [LICENSE.md](LICENSE.md) for more information.
