import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api constants/api_manager.dart';
import '../../api constants/network_constants.dart';
import '../../services/app_toasting.dart';

class ProfileService extends GetxService {
  Future<dynamic> myProfile() async {
    try {
      final response = await apiManager.post(NetworkConstants.getUserProfile, data: {});

      if (response.status != 200) {
        AppToasting.showWarning(response.message);
        return null;
      }
      debugPrint("model Data ${response.data}");
      return response.data;
    } catch (err) {
      AppToasting.showError('Error fetching profile: ${err.toString()}');
      return null;
    }
  }

  Future<dynamic> editProfile(dynamic data) async {
    try {
      final response = await apiManager.post(NetworkConstants.editProfile, data: data);

      if (response.status != 200) {
        AppToasting.showWarning(response.message);
        return null;
      }
      debugPrint("model Data ${response.data}");
      return response.data;
    } catch (err) {
      AppToasting.showError('Error updating profile: ${err.toString()}');
      return null;
    }
  }
}
