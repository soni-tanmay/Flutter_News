import 'package:connectivity/connectivity.dart';

Future<bool> checkConnection() async {
  Connectivity connectivity = Connectivity();
  var connectivityResult = await connectivity.checkConnectivity();
  print('connectivity = $connectivityResult');
  return connectivityResult != ConnectivityResult.none;
}
