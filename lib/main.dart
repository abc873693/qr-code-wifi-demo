// This example shows a [Scaffold] with an [AppBar], a [BottomAppBar] and a
// [FloatingActionButton]. The [body] is a [Text] placed in a [Center] in order
// to center the text within the [Scaffold] and the [FloatingActionButton] is
// centered and docked within the [BottomAppBar] using
// [FloatingActionButtonLocation.centerDocked]. The [FloatingActionButton] is
// connected to a callback that increments a counter.

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_demo/models/wifi_data.dart';
import 'package:qr_code_demo/utils/utils.dart';
import 'package:wifi/wifi.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code Sample for material.Scaffold',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String message = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Barcode Scanner Wifi'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 72,
                child: RaisedButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  onPressed: scan,
                  child: Text(
                    '掃描',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      WifiData wifiData = Utils.parserWifi(barcode);
      if (wifiData == null) {
        setState(() {
          message = 'Wifi格式錯誤';
        });
      }
      var result = await Wifi.connection(wifiData.ssid, wifiData.password);
      setState(() {
        switch (result.index) {
          case 0:
            message = '未知錯誤';
            break;
          case 1:
            message = '連接成功';
            break;
          case 2:
            message = '已經連線至wifi';
            break;
          default:
            message = '未知錯誤';
            break;
        }
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.message = '請取得相機權限';
        });
      } else {
        setState(() => this.message = '未知錯誤: $e');
      }
    } on FormatException {
      setState(() => this.message = '格式錯誤');
    } catch (e) {
      setState(() => this.message = '未知錯誤: $e');
    }
  }
}
