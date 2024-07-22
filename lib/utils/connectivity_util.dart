import 'package:connectivity_plus/connectivity_plus.dart';

/// [ConnectivityService] is a service class that checks for internet connectivity.
class ConnectivityService {
  /// Checks if the device has an internet connection.
  ///
  /// Returns a [Future] containing a [bool] which is `true` if the device is
  /// connected to the internet via mobile data or Wi-Fi, and `false` otherwise.
  Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }
}
