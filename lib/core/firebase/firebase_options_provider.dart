import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../flavor/flavors.dart';
import 'firebase_options_firstcash.dart';
import 'firebase_options_redcash.dart';

final firebaseOptionsProvider =
    Provider.family<FirebaseOptions, Flavor>((ref, flavor) {
  switch (flavor) {
    case Flavor.REDCASH:
      return FirstCashFirebaseOptions.currentPlatform;
    case Flavor.FIRSTCASH:
      return RedCashFirebaseOptions.currentPlatform;
    default:
      return FirstCashFirebaseOptions.currentPlatform;
  }
});
