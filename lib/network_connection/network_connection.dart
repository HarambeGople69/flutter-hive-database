import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';

class CheckConnectivity extends GetxController {
  var isOnline = false.obs;
  CheckConnectivity() {
    Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        // Got a new connectivity status!
        if (result == ConnectivityResult.none) {
          print("No network");
          isOnline.value = false;
        } else if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          print("There is  network");

          isOnline.value = true;
        }
      },
    );
  }
}
