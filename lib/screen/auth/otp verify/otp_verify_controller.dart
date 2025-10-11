import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../services/app_toasting.dart';
import '../../../services/helper.dart';
import '../../../services/notification_service.dart';
import '../auth_service.dart';

class OtpVerifyController extends GetxController {
  final mobile = ''.obs;
  String deviceId = '';
  final verificationCodeController = TextEditingController();
  late final AuthService authService;
  final isLoading = false.obs;
  final isResendEnabled = true.obs;
  final countdown = 30.obs; // Countdown timer starting at 30 seconds
  Timer? _timer;
  String fcmToken = '';


  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    _getDeviceId();
    _getFcmToken();
    final args = Get.arguments;
    if (args != null) {
      mobile.value = args["mobileNo"];
    }
    _startTimer();
  }

  void _initializeServices() {
    try {
      authService = Get.find<AuthService>();
    } catch (e) {
      authService = Get.put(AuthService());
    }
  }

  Future<void> _getFcmToken() async {
    fcmToken = (await notificationService.getToken())!;
    debugPrint("FCM Token: $fcmToken");
  }

  Future<void> _getDeviceId() async {
    deviceId = await helper.getDeviceUniqueId();
    debugPrint("Device ID: $deviceId");
  }

  void _startTimer() {
    isResendEnabled.value = false;
    countdown.value = 30;
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        isResendEnabled.value = true;
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
    verificationCodeController.text = "";
  }

  Future<void> verifyOtp() async {
    if (verificationCodeController.text.trim().isEmpty) {
      AppToasting.showWarning("Please enter OTP");
      return;
    }

    if (verificationCodeController.text.trim().length != 4) {
      AppToasting.showWarning("Please enter valid 4-digit OTP");
      return;
    }

    isLoading.value = true;
    try {
      final request = {"mobileNo": mobile.value, "otpCode": verificationCodeController.text.trim(), "fcm": fcmToken, "deviceId": deviceId};

      debugPrint("OTP Verify Request: $request");

      await authService.otp(request);
    } catch (e) {
      AppToasting.showError("Something went wrong. Please try again.");
      debugPrint("Verify OTP Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    isLoading.value = true;
    try {
      final request = {"mobileNo": mobile.value};
      await authService.reSendOtp(request);
      _startTimer(); // Restart timer after resending OTP
    } catch (e) {
      AppToasting.showError("Something went wrong. Please try again.");
      debugPrint("Resend OTP Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
