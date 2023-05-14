import 'package:easy_localization/easy_localization.dart';

class CustomDateTimeFormatter {

  static String dateFormatter(String? dateTimeData) {
    final formattedDateTime = DateFormat('dd MMM yyyy | h:mm a').format(
        DateTime.parse(dateTimeData!)
    ).toUpperCase();
    return formattedDateTime;
  }

}