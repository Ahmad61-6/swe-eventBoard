import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final _connectivity = Connectivity();
  final isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(
        result != ConnectivityResult.none ? result : [ConnectivityResult.none],
      );
    } catch (e) {
      print('Connectivity initialization error: $e');
      isConnected.value = false;
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    try {
      if (results.isEmpty) {
        isConnected.value = false;
        return;
      }
      isConnected.value = results.first != ConnectivityResult.none;
    } catch (e) {
      print('Connectivity update error: $e');
      isConnected.value = false;
    }
  }
}
