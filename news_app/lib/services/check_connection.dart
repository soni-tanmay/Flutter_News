import 'package:connectivity/connectivity.dart';

Future<bool> checkConnection() async {
  Connectivity connectivity = Connectivity();
  var connectivityResult = await connectivity.checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}
