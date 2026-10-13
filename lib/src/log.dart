import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// Copyright 2024-2026 ProntoGUI, LLC
// ProntoGUI™ is a trademark of ProntoGUI, LLC
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// [LoggingLevel]s to control logging output. Logging can be enabled to include all
/// levels above certain [Level].
enum LoggingLevel {
  /// Designates finer-grained "trace" informational events than the [debug] level.
  trace,

  /// Designates fine-grained informational events that are most useful to debug
  /// an application.
  debug,

  /// Designates informational messages that highlight the state of the application
  /// or special conditions.
  info,

  /// Designates potentially harmful situations.
  warning,

  /// Designates error events that might still allow the application to continue.
  error,

  /// Designates very severe error events that will presumably end the application.
  fatal,

  /// All log messages are disabled.
  off;
}

class _LogItem {
  _LogItem(this.level, this.message, this.time, this.error, this.stackTrace);

  final Level level;
  final dynamic message;
  final DateTime? time;
  final Object? error;
  final StackTrace? stackTrace;
}

class BootLogger {

  final List<_LogItem> _heldLogItems = [];
  Logger? _redirectLogger;

  void _transferToLogger(Logger logger) {
    for (final item in _heldLogItems) {
      final call = switch(item.level) {
        Level.trace => logger.t,
        Level.debug => logger.d,
        Level.info => logger.i,
        Level.warning => logger.w,
        Level.error => logger.e,
        Level.fatal => logger.f,
        _ => null,
      };
      if (call != null) {
        call(item.message, time: item.time, error: item.error, stackTrace: item.stackTrace);
      }
    }
    _heldLogItems.clear();
    _redirectLogger = logger;
  }

  /// Log a message at level [Level.trace].
  void t(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_redirectLogger != null) {
      _redirectLogger!.t(message, time: time, error: error, stackTrace: stackTrace);
      return;
    }
    _heldLogItems.add(_LogItem(Level.trace, message, time, error, stackTrace));
  }

  /// Log a message at level [Level.debug].
  void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_redirectLogger != null) {
      _redirectLogger!.d(message, time: time, error: error, stackTrace: stackTrace);
      return;
    }
    _heldLogItems.add(_LogItem(Level.debug, message, time, error, stackTrace));
  }

  /// Log a message at level [Level.info].
  void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_redirectLogger != null) {
      _redirectLogger!.i(message, time: time, error: error, stackTrace: stackTrace);
      return;
    }
    _heldLogItems.add(_LogItem(Level.info, message, time, error, stackTrace));
  }

  /// Log a message at level [Level.warning].
  void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_redirectLogger != null) {
      _redirectLogger!.w(message, time: time, error: error, stackTrace: stackTrace);
      return;
    }
    _heldLogItems.add(_LogItem(Level.warning, message, time, error, stackTrace));
  }

  /// Log a message at level [Level.error].
  void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_redirectLogger != null) {
      _redirectLogger!.e(message, time: time, error: error, stackTrace: stackTrace);
      return;
    }
    _heldLogItems.add(_LogItem(Level.error, message, time, error, stackTrace));
  }

  /// Log a message at level [Level.fatal].
  void f(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_redirectLogger != null) {
      _redirectLogger!.f(message, time: time, error: error, stackTrace: stackTrace);
      return;
    }
    _heldLogItems.add(_LogItem(Level.fatal, message, time, error, stackTrace));
  }
}

/// Access the single instance of the boot up Logger.
/// 
/// The boot logger is used for preliminary construction work that
/// happens before the regular logger is initialized. This might be 
/// work leading up to creating the first window, after which subsequent
/// log entries are tied to the window.
final bootLogger = BootLogger();

/// Access the single instance of the Logger.
/// 
/// This is the logger for all events occurring after preliminary construction.
/// Events given to this logger will be associated to the window corresponding
/// to "this" flutter engine.
late final Logger logger;

/// Set the logging level for the Logger.
set loggingLevel(LoggingLevel loggingLevel) {
  late Level level;
  switch (loggingLevel) {
    case LoggingLevel.trace:
      level = Level.trace;
    case LoggingLevel.debug:
      level = Level.debug;
    case LoggingLevel.info:
      level = Level.info;
    case LoggingLevel.warning:
      level = Level.warning;
    case LoggingLevel.error:
      level = Level.error;
    case LoggingLevel.fatal:
      level = Level.fatal;
    case LoggingLevel.off:
      level = Level.off;
  }
  Logger.level = level;
}

/// The full path of the root location where all logs are stored.
late final String _logsRootPath;
String get logsRootPath => _logsRootPath;

/// The full path where log files are stored for our application instance.
late final String _logsPath;
String get logsPath => _logsPath;


/// Initializes the logging system.
/// 
/// [logGroup] - specifies a group name to store log files under. This is needed when an application
/// has multiple windows, each running a separate Flutter engine, and a single log file won't suffice.
/// If this is null then log files are written to the default location. 
/// 
/// [maxFileSizeKB] controls the log file rotation. The output automatically
/// switches to a new log file as soon as the current file exceeds it.
/// Use -1 to disable log rotation.
/// 
/// [maxRotatedFilesCount] controls the number of rotated files to keep. By default
/// is null, which means no limit.
/// If set to a positive number, the output will keep the last
/// [maxRotatedFilesCount] files.
Future<void> initializeLogging({
  String? logGroup,
  int maxFileSizeKB = 1024,
  int? maxRotatedFilesCount
}) async {

    // Determine the path where we can safely store log files
    var supportDir = await getApplicationSupportDirectory();

    _logsRootPath = path.join(supportDir.path, 'logs');

    if (logGroup != null) {
      _logsPath = path.join(_logsRootPath, logGroup);
    } else {
      _logsPath = path.join(_logsRootPath, 'default');
    }

    var printer = SimplePrinter(printTime: true, colors: false);

    var output = AdvancedFileOutput(
      path: logsPath,
      maxFileSizeKB: maxFileSizeKB,
      maxRotatedFilesCount: maxRotatedFilesCount
    );

    logger = Logger(printer: printer, output: output);

    // Transfer boot log items
    bootLogger._transferToLogger(logger);
}
