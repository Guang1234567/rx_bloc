part of rx_bloc_generator;

/// The global logJet symbol.
const Symbol _logKey = #buildLog;

/// Fallback logger used in case there isn't any in the current zone
final _default = Logger('build.fallback');

/// The log instance for the currently running BuildStep.
///
/// Will be `null` when not running within a build.
Logger get log => Zone.current[_logKey] as Logger ?? _default;

/// Logs message as a `severe` error displayed in red color for easier noticing.
void _logError(String str) {
  final exceptionStr = 'Exception: ';
  var msg = str;
  if (msg.contains(exceptionStr)) {
    msg = msg.substring(msg.indexOf(exceptionStr) + exceptionStr.length);
  }
  msg = '[ERROR] $msg';
  log.severe('\n${msg.toRedString()}\n');
}

/// Logs a package error with the suggestion to report it
void _reportIssue(String msg, String copyBlock) {
  _logError(msg +
      '\n\nPlease, report the problem at https://github.com/Prime-Holding/rx_bloc/issues '
          'providing the information form the `COPY BLOCK` below.'
          '\n\n'
          '----------START COPY BLOCK----------\n\n' +
      copyBlock +
      '\n\n----------END COPY BLOCK----------\n');
}
