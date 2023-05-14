
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'flavors.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 08,February,2023.

final flavorProvider = StateProvider<Flavor>((ref) {
  return Flavor.FIRSTCASH;
});