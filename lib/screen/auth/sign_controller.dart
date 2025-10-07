import 'package:coolie_passanger/services/app_toasting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '/screen/auth/auth_service.dart';
import '../../routes/route_name.dart';
import '../../services/helper.dart';

class SignController extends GetxController {
  final isLoading = false.obs;
  final mobileController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String deviceId = '';
  late final AuthService authService;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    mobileController.text = '';
    _getDeviceId();
  }

  void _initializeServices() {
    try {
      authService = Get.find<AuthService>();
    } catch (e) {
      authService = Get.put(AuthService());
    }
  }

  Future<void> _getDeviceId() async {
    deviceId = await helper.getDeviceUniqueId();
    debugPrint("Device ID: $deviceId");
  }

  Future<void> signIn() async {
    isLoading.value = true;

    if (mobileController.text.isEmpty) {
      AppToasting.showWarning("Please Enter the mobile number");
    }

    final response = await authService.signIn(mobileNo: mobileController.text, deviceId: deviceId, fcm: "");

    isLoading.value = false;
    debugPrint("RESPONSE $response");
    if (response != null) {
      debugPrint("SignIn Response: ${response}");
      Get.offAllNamed(RouteName.otpVerification, arguments: {"mobileNo": mobileController.text});
    }
  }

  @override
  void onClose() {
    super.onClose();
    mobileController.text = "";
  }
}
