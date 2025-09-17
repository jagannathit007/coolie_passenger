

import 'dart:convert';

import 'package:coolie_passanger/routes/route_name.dart';
import 'package:coolie_passanger/services/app_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


import '../api constants/api_manager.dart';
import '../api constants/network_constants.dart';
import '../models/register_model.dart';
import '../models/sign_in_model.dart';
import '../models/user_model.dart';
import '../services/app_toasting.dart';

class AuthenticationRepo {
  Future<AuthenticationRepo> init() async => this;

  // AuthenticationRepo
  Future<SignInResponseModel?> signIn({
    required String mobileNo,
    required String deviceId,
    required String fcm,
  }) async {
    try {
      final result = await apiManager.post(
        NetworkConstants.signIn,
        data: {
          "mobileNo": mobileNo,
          "deviceId": deviceId,
          "fcm": fcm,
        },
      );

      debugPrint("SignIn Raw Response: ${result.data}");

      if (result.data is Map<String, dynamic>) {
        return SignInResponseModel.fromJson(result.data);
      } else {
        debugPrint("Invalid response format: ${result.data}");
        return null;
      }
    } catch (e, stack) {
      debugPrint("SignIn API Error: $e\n$stack");
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
        data: {
          "name": name,
          "mobileNo": mobileNo,
          "emailId": email ?? "",
          "latitude": latitude,
          "longitude": longitude,
          "addressComponent": addressComponent,
        },
      );

      debugPrint("Register Raw Response: ${result.data}");

      final resultData = result.data;

      if (resultData != null && resultData['data'] != null) {
        final data = resultData['data'] as Map<String, dynamic>;
        return RegisterUserModel.fromJson(data);
      } else {
        debugPrint("Register API returned null or invalid data: $resultData");
        return null;
      }
    } catch (e, stack) {
      debugPrint("Register API Error: $e\n$stack");
      AppToasting.showError("Failed to register user");
      return null;
    }
  }

  Future<void> otp(request) async {
    try {
      final response = await apiManager.post(NetworkConstants.otpVerification,data: request);
      final verifyData = response.data;
      if (response.status  != 200) {
        AppToasting.showWarning(response.data?.message ?? 'Something went wrong');
        return;
      }
      await AppStorage.write("token", verifyData["token"]);
      await AppStorage.write("passengerID", verifyData["user"]["_id"]);
      debugPrint("passengerID ${verifyData["user"]["_id"]}");
      await AppStorage.write("user", verifyData["user"]);
      Get.toNamed(RouteName.travelHomeScreen);
    } catch (err) {
      debugPrint("error ${err.toString()}");
      AppToasting.showError(err.toString());
      return;
    }
  }


  Future<dynamic> bookCoolie(data) async {
    try {
      // final body;
      final response = await apiManager.post(NetworkConstants.bookCoolie,data: data);
      if (response.status != 200) {
        AppToasting.showWarning(response.data?.message ?? 'Failed to create lead');
        return;
      }
      return response.data;
    } catch (err) {
      AppToasting.showError('Error creating lead: $err');
      return;
    }
  }

  Future<dynamic> myProfile() async {
    try {
      final response = await apiManager.post(NetworkConstants.getUserProfile, data: {});

      if (response.status != 200) {
        AppToasting.showWarning(response.data?.message ?? 'Failed to fetch profile');
        return null;
      }
      debugPrint("model Data ${response.data}");
      return response.data;
    } catch (err) {
      AppToasting.showError('Error fetching profile: ${err.toString()}');
      return null;
    }
  }




}
