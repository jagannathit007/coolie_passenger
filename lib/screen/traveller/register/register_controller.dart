import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../repository/authentication_repo.dart';
import '../../../routes/route_name.dart';
import '../../../services/app_toasting.dart';

class RegisterController extends GetxController {
  final isLoading = false.obs;

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  String? latitude;
  String? longitude;
  String? pincode;
  String? city;
  String? state;

  final AuthenticationRepo authenticationRepo = Get.find();

  final registerFormKey = GlobalKey<FormState>();

  void setLocation({
    required String fullAddress,
    required String lat,
    required String long,
    required String pincode,
    required String city,
    required String state,
  }) {
    addressController.text = fullAddress;
    latitude = lat;
    longitude = long;
    this.pincode = pincode;
    this.city = city;
    this.state = state;
  }

  Future<void> registerUser() async {
    if (nameController.text.isEmpty ||
        mobileController.text.isEmpty ||
        addressController.text.isEmpty) {
      AppToasting.showError("Please fill all required fields");
      return;
    }

    if (pincode == null || city == null || state == null) {
      AppToasting.showError("Location must include pincode, city, and state");
      return;
    }

    isLoading.value = true;

    final response = await authenticationRepo.registerUser(
      name: nameController.text,
      mobileNo: mobileController.text,
      email: emailController.text,
      latitude: latitude ?? "0",
      longitude: longitude ?? "0",
      addressComponent: {
        "pincode": pincode!,
        "city": city!,
        "state": state!,
      },
    );

    isLoading.value = false;

    if (response != null) {
      AppToasting.showSuccess("User registered successfully!");
      Get.toNamed(RouteName.signIn);
    }
  }
}
