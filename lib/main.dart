import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String serialNumber = "N/A";

  static const platform = MethodChannel('spozebra/identifiers');

@override
  void initState() {
    super.initState();
    _initEmdk();
    // wait emdk (temp)
    sleep(Duration(seconds: 5));

    // Adding just the characteristic as we will use the default profile
    _setProfile("""
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
</wap-provisioningdoc>

""");

    _getSerialNumber();
  }

  _initEmdk() async {
    try {
      await platform.invokeMethod('initEmdk');
    } on PlatformException catch (e) {
        log(e.stacktrace ?? "");
    }
  }

  _setProfile(String xml) async {
    try {
      await platform.invokeMethod('setProfile', {"xml" : xml});
    } on PlatformException catch (e) {
        log(e.stacktrace ?? "");
    }
  }
  _getSerialNumber() async {
    try {
      var sn = await platform.invokeMethod('getSerialNumber');
      log(sn);
      setState(() {
        serialNumber = sn as String;
      });

    } on PlatformException catch (e) {
        log(e.stacktrace ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Serial Number:',
            ),
            Text(
              serialNumber,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
