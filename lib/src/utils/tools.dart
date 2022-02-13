import 'package:connectivity/connectivity.dart';

Future<bool> checkInternet() async {
  switch (await Connectivity().checkConnectivity()) {
    case ConnectivityResult.mobile:
      return true;
      break;
    case ConnectivityResult.wifi:
      return true;
      break;
    default:
      return false;
  }
}
