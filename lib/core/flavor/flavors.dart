/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 08,February,2023.

enum Flavor { REDCASH, FIRSTCASH }

class AppFlavor {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.REDCASH:
        return 'RedCash - DFS';
      case Flavor.FIRSTCASH:
        return 'FirstCash - DFS';
      default:
        return 'DFS';
    }
  }

}
