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
  int _counter = 0;

  static const platform = MethodChannel('spozebra/identifiers');

@override
  void initState() {
    super.initState();
    _initEmdk();
    sleep(Duration(seconds: 5));
    // wait a lot
    _setProfile("""<wap-provisioningdoc>
                <characteristic type="ProfileInfo">
                    <parm name="created_wizard_version" value="11.0.1" />
                </characteristic>
                <characteristic type="Profile">
                    <parm name="ProfileName" value="OEMService" />
                    <parm name="ModifiedDate" value="2022-08-17 10:20:36" />
                    <parm name="TargetSystemVersion" value="10.4" />
                    <characteristic type="AccessMgr" version="10.4">
                        <parm name="emdk_name" value="" />
                        <parm name="ServiceAccessAction" value="4" />
                        <parm name="ServiceIdentifier" value="content://oem_info/oem.zebra.secure/build_serial" />
                        <parm name="CallerPackageName" value="com.spozebra.flutter_zebra_device_ids" />
                        <parm name="CallerSignature" 
                            value="MIIC5DCCAcwCAQEwDQYJKoZIhvcNAQEFBQAwNzEWMBQGA1UEAwwNQW5kcm9pZCBEZWJ1ZzEQMA4GA1UECgwHQW5kcm9pZDELMAkGA1UEBhMCVVMwIBcNMjIwNTEyMDg1NDA1WhgPMjA1MjA1MDQwODU0MDVaMDcxFjAUBgNVBAMMDUFuZHJvaWQgRGVidWcxEDAOBgNVBAoMB0FuZHJvaWQxCzAJBgNVBAYTAlVTMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqFON7xnLjUCBau4ZKgVlgN0jdP9JfcKE8nev7F5eD/OeLZOR/GCVzJrj29MohR2eonVDWM+kCdBkth8WbsMgc9oLIkdhq1OeOH2JjQRV38X4MQfR/ldz/NoVLPj9oyCNEBEvzCe1z9siHKNWpSqcZj6aimqpyHkBH+2mD9PKyt4a6520J+61E1MOJiS39Ch8pNxJsJ5c9/w1Hb2sURYLe33TPOZfhjcqh5BhNn+qVBoUvabcKuVxh+m0+ltaM1nHbFpKMa+foQVsbQB8wmLiB7F+yE2R0d4UmBqErAM/tQOKp0ZLu3L1jySbRLS1Sf+IbT8ymnirwcvMXC/KzQ/lFQIDAQABMA0GCSqGSIb3DQEBBQUAA4IBAQCF+JRAC8kPuAJxIxVOxCLwcXS5FvwNwbgEvh8hEbAJwYYelN6weq9EmZurfSzGmxPkhSiqp6F9biTcHHUOKGR9Yty1uZkoRl1/+VLVzGrvPfdFwGoXXoSBPrx3Lj36RysZw0kwwJMD+5ovTzemsiVjm92YrAxFXO8XhXRVHGmncLRNi36Mzm6VdtnhkIKlALFLYvxHEQpghOw2K1Po5XJqFw5twQsv+snoFrjv+8f8MltoqEuVnUhP/NRAF1kUbt1IhgPzx0m5HXAHfl5S06p97UbIFtmvBNSFQyMMwoTXUvWcIuHPImcCDdFcB1g4j//TlznE8vgkpiCrQV/q2zb8" />
                    </characteristic>
                </characteristic>
            </wap-provisioningdoc>""");
  }

  _initEmdk() async {
    try {
      await platform.invokeMethod('initEmdk');
    } on PlatformException catch (e) {
        log(e.stacktrace ?? "");
    }
  }

  _setProfile(String xmlProfile) async {
    try {
      await platform.invokeMethod('setProfile', {"xmlProfile" : xmlProfile});
    } on PlatformException catch (e) {
        log(e.stacktrace ?? "");
    }
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
