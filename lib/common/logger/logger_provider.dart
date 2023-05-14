import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final setupLoggingProvider = Provider<SetupLogging>((ref) {
  return SetupLogging();
});

class SetupLogging {

  SetupLogging() {
    _init();
  }

  void _init() async{

    if (kDebugMode) {
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((event) {

        if (event.level == Level.SEVERE) {
          debugPrint("FirstCash ==> ${event.level.name}: ${event.time} : ${event.message} : ${event.error} : ${event.stackTrace}");
        }
        else if (event.level == Level.INFO) {
          debugPrint("FirstCash ==> ${event.loggerName} : ${event.message} ");
        }
        else {
          debugPrint("FirstCash ==> ${event.level.name}: ${event.loggerName} : ${event.time} : ${event.message}");
        }
      });

    }
    else {
      Logger.root.level = Level.OFF;
    }

  }
}