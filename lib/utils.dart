import 'package:intl/intl.dart';

class Utils {
  static String formatDateString(DateTime dateString) {
    DateTime dateTime = DateTime.parse(dateString.toString());
    var formater = DateFormat('HH:mm');
    return formater.format(dateTime);
  }
}
