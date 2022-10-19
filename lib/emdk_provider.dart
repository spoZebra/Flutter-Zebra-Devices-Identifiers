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
      setProfile("""
        <wap-provisioningdoc>
      <characteristic type="ProfileInfo">
        <parm name="created_wizard_version" value="11.0.0"/>
      </characteristic>
      <characteristic type="Profile">
        <parm name="ProfileName" value="MyProfile"/>
        <parm name="ModifiedDate" value="2022-10-19 10:42:21"/>
        <parm name="TargetSystemVersion" value="10.4"/>
          
        <characteristic type="AccessMgr" version="10.4">
          <parm name="emdk_name" value="accessManager"/>
          <parm name="ServiceAccessAction" value="4"/>
          <parm name="ServiceIdentifier" value="content://oem_info/oem.zebra.secure/build_serial"/>
          <parm name="CallerPackageName" value="com.spozebra.flutter_zebra_device_ids"/>
          <parm name="CallerSignature" value="MIIDZzCCAk+gAwIBAgIEQhPGQTANBgkqhkiG9w0BAQsFADBkMQswCQYDVQQGEwJJVDEOMAwGA1UECBMFTWlsYW4xDjAMBgNVBAcTBU1pbGFuMRswGQYDVQQLExJaZWJyYSBUZWNobm9sb2dpZXMxGDAWBgNVBAMTD1NpbW9uZSBQb3p6b2JvbjAeFw0yMjEwMTgxNDQwMDBaFw00NzEwMTIxNDQwMDBaMGQxCzAJBgNVBAYTAklUMQ4wDAYDVQQIEwVNaWxhbjEOMAwGA1UEBxMFTWlsYW4xGzAZBgNVBAsTElplYnJhIFRlY2hub2xvZ2llczEYMBYGA1UEAxMPU2ltb25lIFBvenpvYm9uMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkzfqijH+SS/JhzuFioWWf+w3+yIsN0kuqKINlK8ZmWCB0lFC6rItI++6q5vFnr1idS0miBPA03l/29JAGtZtpRIe1fdo/+NsajxSZ9K5EXgMEw9a7AMt3cKbI77itK2r1hCpMi6gLt/3KEn6tkHVBc5GwLXx+OLr7rOo4NNMqB6ysKYTpIZgP6GSoVS1GJyF9Iq4ADJVMZYUO5TuucniCveCxylR8VGTJjIir3stjGuhB85xEOvgMsIaUfur2AIjJxfzwQ0VSRdow4UlHl9NoTBrRtmz+6rAdlYGb/JgwvuU3GNp3keheejmf2FfUWSk9g/k4D7rPjCx5z5sqVnG7QIDAQABoyEwHzAdBgNVHQ4EFgQUVIcAnVgaNILeuFxEbOyRzQcrNvswDQYJKoZIhvcNAQELBQADggEBACRilc4zfcNnpeBl12Vf91lEH4Il/hlOkocP5/4N89SNTgDAAcXPApv6UxOteM3fv74oYnzwhq/FNziYAtDwgGdHqVpSeR7pKdQbt5PYdYHJ8Bp6EDA60Nq7hhIvfjMRLko41XNwKJA0ERk/nLPwS1STIS4KCmv999R0GewLWW03Tkz1E313aJZcHJ85KxI/DQzTO2YK0kuWfcE62/LdGkxA79JNTcBHVDQ00jPx8yKTafAXRQRFFReM3lcnb5NfpN7EQe3YaXYi8KEk9E41xN5kjYd2LDv0yF1jZKZIJVqqQdVnr1LqY8MGRgFur01atujkxcSjobTwZvFfr5Z+/h0="/>
        </characteristic>
      </characteristic>
    </wap-provisioningdoc>""");
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

  setProfile(String xml) async {
    try {
      await platform.invokeMethod('setProfile', {"xml": xml});
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
