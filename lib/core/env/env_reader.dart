
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../flavor/flavor_provider.dart';
import '../flavor/flavors.dart';
/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 10,January,2023.

final envReaderProvider = Provider<EnvReader>((ref) {
  final flavor = ref.watch(flavorProvider);
  return EnvReader(flavor);
});

class EnvReader {
  final Flavor _flavor;

  EnvReader(this._flavor);

  String getEnvFileName() {
    switch (_flavor) {
      case Flavor.REDCASH:
        return ".redcash.env";
      case Flavor.FIRSTCASH:
        return ".firstcash.env";
      default:
        throw Exception(".env file not found");
    }
  }

  String getBaseUrl() {
    return dotenv.get('BASE_URL');
  }

  String getApplicationId() {
    return dotenv.get('applicationId');
  }

}
