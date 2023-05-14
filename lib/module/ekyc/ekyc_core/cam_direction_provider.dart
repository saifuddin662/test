import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'camera_direction_type.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 08,February,2023.

final camDirectionProvider =
    StateNotifierProvider<CamDirectionNotifier, CamDirection>(
        (_) => CamDirectionNotifier(CamDirection.back));

class CamDirectionNotifier extends StateNotifier<CamDirection> {
  CamDirectionNotifier(CamDirection state) : super(state);

  void updateDirection(CamDirection direction) {
    state = direction;
  }
}
