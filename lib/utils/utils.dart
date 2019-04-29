import 'package:qr_code_demo/models/wifi_data.dart';

class Utils {
  static WifiData parserWifi(String rawText) {
    String type;
    String ssid;
    String password;
    if (!rawText.startsWith("WIFI:")) {
      return null;
    }
    rawText = rawText.substring("WIFI:".length);
    List<String> list = rawText.split(';');
    list.forEach((text) {
      if (text.length >= 2) {
        switch (text.substring(0, 2)) {
          case 'T:':
            type = text.substring(2);
            break;
          case 'S:':
            ssid = text.substring(2);
            break;
          case 'P:':
            password = text.substring(2);
            break;
          default:
            break;
        }
      }
    });
    if (type == null)
      return null;
    else if (type == 'WPA' || type == 'WEP') {
      if (ssid == null || password == null) return null;
    } else if (type == 'nopass') {
      if (ssid == null) return null;
      password = '';
    }
    return WifiData(
      type: type,
      ssid: ssid,
      password: password,
    );
  }
}
