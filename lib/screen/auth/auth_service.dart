import 'dart:developer';
import 'package:get/get.dart';
import '../../api constants/api_manager.dart';
import '../../api constants/network_constants.dart';
import '../../models/register_model.dart';
import '../../models/sign_in_model.dart';
import '../../routes/route_name.dart';
import '../../services/app_storage.dart';
import '../../services/app_toasting.dart';

class AuthService extends GetxService {
  Future<SignInResponseModel?> signIn({required String mobileNo, required String deviceId, required String fcm}) async {
    try {
      final result = await apiManager.post(NetworkConstants.signIn, data: {"mobileNo": mobileNo, "deviceId": deviceId, "fcm": fcm});

      log("SignIn Raw Response: ${result.data}");

      if (result.data is Map<String, dynamic>) {
        AppToasting.showSuccess(result.message);
        return SignInResponseModel.fromJson(result.data);
      } else {
        AppToasting.showWarning(result.message);
        log("Invalid response format: ${result.data}");
        return null;
      }
    } catch (e, stack) {
      log("SignIn API Error: $e\n$stack");
      AppToasting.showError(e.toString());
      return null;
    }
  }

  Future<RegisterUserModel?> registerUser({
    required String name,
    required String mobileNo,
    String? email,
    required String latitude,
    required String longitude,
    required Map<String, dynamic> addressComponent,
  }) async {
    try {
      final result = await apiManager.post(
        NetworkConstants.signUp,
        data: {"name": name, "mobileNo": mobileNo, "emailId": email ?? "", "latitude": latitude, "longitude": longitude, "addressComponent": addressComponent},
      );

      if (result.status == 200 && result.data != null) {
        final data = result.data as Map<String, dynamic>;
        AppToasting.showSuccess(result.message);
        return RegisterUserModel.fromJson(data);
      } else {
        log("Register API returned null or invalid data: ${result.data}");
        AppToasting.showInfo(result.message);
        return null;
      }
    } catch (e, stack) {
      log("Register API Error: $e\n$stack");
      AppToasting.showError("Failed to register user");
      return null;
    }
  }

  Future<void> otp(dynamic request) async {
    try {
      final response = await apiManager.post(NetworkConstants.otpVerification, data: request);

      if (response.data == null) {
        AppToasting.showError("Invalid response from server");
        return;
      }

      if (response.status != 200 || response.message == "Invalid or expired OTP") {
        AppToasting.showWarning(response.message);
        return;
      }

      final verifyData = response.data;

      if (verifyData["token"] == null) {
        AppToasting.showError("Authentication token not received");
        return;
      }

      await AppStorage.write("token", verifyData["token"]);
      await AppStorage.write("passengerID", verifyData["user"]["_id"]);
      log("passengerID ${verifyData["user"]["_id"]}");
      await AppStorage.write("user", verifyData["user"]);
      Get.toNamed(RouteName.travelHomeScreen);
    } catch (err) {
      log("error ${err.toString()}");
      AppToasting.showError(err.toString());
      return;
    }
  }

  Future<void> reSendOtp(dynamic request) async {
    try {
      final response = await apiManager.post(NetworkConstants.otpVerification, data: request);

      if (response.data == null) {
        AppToasting.showError("Invalid response from server");
        return;
      }

      if (response.status != 200) {
        AppToasting.showWarning(response.message);
        return;
      }

      final verifyData = response.data;

      if (verifyData["token"] == null) {
        AppToasting.showError("Authentication token not received");
        return;
      }

      await AppStorage.write("token", verifyData["token"]);
      await AppStorage.write("passengerID", verifyData["user"]["_id"]);
      log("passengerID ${verifyData["user"]["_id"]}");
      await AppStorage.write("user", verifyData["user"]);
      Get.toNamed(RouteName.travelHomeScreen);
    } catch (err) {
      log("error ${err.toString()}");
      AppToasting.showError(err.toString());
      return;
    }
  }
}
