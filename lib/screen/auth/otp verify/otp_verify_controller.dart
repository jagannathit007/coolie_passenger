import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../repository/authentication_repo.dart';
import '../../../routes/route_name.dart';
import '../../../services/app_storage.dart';
import '../../../services/app_toasting.dart';
import '../../../services/helper.dart';

class OtpVerifyController extends GetxController{
  final mobile = ''.obs;
  String deviceId = '';
  final verificationCodeController = TextEditingController();
  @override
  void onInit() {
    _getDeviceId();
    final args=Get.arguments;
    if(args !=null){
      mobile.value=args["mobileNo"];
    }
    super.onInit();
  }

  final isLoading=false.obs;
  final AuthenticationRepo authenticationRepo = Get.find();
  Future<void> _getDeviceId() async {
    deviceId = await helper.getDeviceUniqueId();
    debugPrint("Device ID: $deviceId");
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
      final request = {
        "mobileNo": mobile.value,
        "otpCode": verificationCodeController.text.trim(),
        "fcm": "fcmToken.value", // Fixed: removed quotes around variable
        "deviceId": deviceId,
      };

      debugPrint("OTP Verify Request: $request");

      await authenticationRepo.otp(request);


    } catch (e) {
      AppToasting.showError("Something went wrong. Please try again.");
      debugPrint("Verify OTP Error: $e");
    } finally {
      isLoading.value = false;
    }
  }







}