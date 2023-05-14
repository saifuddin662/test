import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_crashlytics_provider.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 22,February,2023.

final crashlyticsProvider = Provider<Crashlytics>((ref) {
  final crashlytics = ref.watch(firebaseCrashlyticsProvider);

  return Crashlytics(crashlytics);

});

class Crashlytics {
  final FirebaseCrashlytics _crashlytics;

  Crashlytics(this._crashlytics) {
    _init();
  }

  void _init() async {
    if (kDebugMode) {
      await _crashlytics.setCrashlyticsCollectionEnabled(true); //todo shaj need to set false for production
    }
    else {
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
    }
  }

  //identify user
  Future<void> setUser(String user) async {
    await _crashlytics.setUserIdentifier(user);
  }

  Future<void> nonFatalCrash({required dynamic exception, StackTrace? stack, String? reason})  async {
    if (_crashlytics.isCrashlyticsCollectionEnabled) {
      await _crashlytics.recordError(
        exception, 
        stack,
        reason: reason ?? 'Non_fatal Error',
      );
    }
  }
  
}