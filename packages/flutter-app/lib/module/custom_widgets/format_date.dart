import 'package:intl/intl.dart';

String convertDate(DateTime timestamp) {
  String dateString = DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
  return dateString;
}
