
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class IpAddress extends StatefulWidget {
  IpAddress({Key? key}) : super(key: key);

  @override
  IpAddressState createState() => IpAddressState();
}

class IpAddressState extends State<IpAddress> {
  static Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
      // I am connected to a wifi network.
    } else {
      return false;
    }
  }

//  static String ipAddress = 'http://192.168.0.48:2121';
//   static String ipAddress ='http://192.168.0.44:1515'; // TODO:LOCALHOST SERVICE
  //static String ipAddress = 'http://mob.indusnovateur.in:2121'; // TODO:PUBLICIP SERVICE

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
