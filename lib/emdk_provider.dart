import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_zebra_device_ids/serialnumber_notifier.dart';

class EmdkProvider {
  static const platform = MethodChannel('spozebra/identifiers');
  SerialNumberNotifier serialNumberNotifier;

  EmdkProvider(this.serialNumberNotifier) {
    platform.setMethodCallHandler(_processEngineOutput);
  }

  Future<void> _processEngineOutput(MethodCall call) async {
    if (call.method == 'emdkOpened') {
      // Download profiles
      setProfile("AccessMgrSerialNum");
      // Get serial number
      getSerialNumber();
    }
  }

  initEmdk() async {
    try {
      await platform.invokeMethod('initEmdk');
    } on PlatformException catch (e) {
      log(e.stacktrace ?? "");
    }
  }

  setProfile(String profileName) async {
    try {
      await platform.invokeMethod('setProfile', {"profileName": profileName});
    } on PlatformException catch (e) {
      log(e.stacktrace ?? "");
    }
  }

  getSerialNumber() async {
    try {
      var sn = await platform.invokeMethod('getSerialNumber');
      log(sn);
      serialNumberNotifier.setSerial(sn);
    } on PlatformException catch (e) {
      log(e.stacktrace ?? "");
    }
  }
}
