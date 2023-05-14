import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/model/global_data_controller.dart';
/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 18,January,2023.
final globalDataControllerProvider =
    Provider<GlobalDataController>((_) => GlobalDataController.instance);
