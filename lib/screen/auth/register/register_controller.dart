import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/route_name.dart';
import '../../../services/app_toasting.dart';
import '../auth_service.dart';
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController {
  final isLoading = false.obs;
  final Rxn<File> profileImage = Rxn<File>();
  final ImagePicker _imagePicker = ImagePicker();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  String? latitude;
  String? longitude;
  String? pincode;
  String? city;
  String? state;

  late final AuthService authService;
  final registerFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }

  void _initializeServices() {
    try {
      authService = Get.find<AuthService>();
    } catch (e) {
      authService = Get.put(AuthService());
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? picked = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (picked != null) profileImage.value = File(picked.path);
    } catch (e) {
      AppToasting.showError('Failed to capture image');
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? picked = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked != null) profileImage.value = File(picked.path);
    } catch (e) {
      AppToasting.showError('Failed to pick image');
    }
  }

  void removeProfileImage() {
    profileImage.value = null;
  }

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
    if (nameController.text.isEmpty || mobileController.text.isEmpty || addressController.text.isEmpty) {
      AppToasting.showError("Please fill all required fields");
      return;
    }

    if (pincode == null || city == null || state == null) {
      AppToasting.showError("Location must include pincode, city, and state");
      return;
    }

    isLoading.value = true;

    final response = await authService.registerUser(
      name: nameController.text,
      mobileNo: mobileController.text,
      email: emailController.text,
      latitude: latitude ?? "0",
      longitude: longitude ?? "0",
      addressComponent: {"pincode": pincode!, "city": city!, "state": state!},
    );

    isLoading.value = false;

    if (response != null) {
      AppToasting.showSuccess("User registered successfully!");
      Get.toNamed(RouteName.signIn);
    }
  }

  @override
  void onClose() {
    super.onClose();
    nameController.text = "";
    mobileController.text = "";
    emailController.text = "";
    addressController.text = "";
    latitude = "";
    longitude = "";
    pincode = "";
    city = "";
    state = "";
  }
}
