import 'package:flutter_riverpod/flutter_riverpod.dart';

class SerialNumberNotifier extends StateNotifier<String> {
  SerialNumberNotifier() : super("N/A");

  void setSerial(String serialNumber) => state = serialNumber;
}
