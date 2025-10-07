import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/get_user_profile_model.dart';
import '../../routes/route_name.dart';
import '../../services/app_storage.dart';
import '../../services/app_toasting.dart';
import 'profile_service.dart';

class ProfileController extends GetxController {
  final isLoading = false.obs;
  Rx<GetUserProfile> userProfile = GetUserProfile().obs;
  final Rxn<File> profileImage = Rxn<File>();
  final ImagePicker _imagePicker = ImagePicker();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  String? latitude;
  String? longitude;
  String? pincode;
  String? city;
  String? state;
  late final ProfileService profileService;
  final editFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    fetchProfile();
  }

  void _initializeServices() {
    try {
      profileService = Get.find<ProfileService>();
    } catch (e) {
      profileService = Get.put(ProfileService());
    }
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final response = await profileService.myProfile();
      if (response != null) {
        userProfile.value = GetUserProfile.fromJson(response);
        nameController.text = userProfile.value.user?.name ?? "";
        emailController.text = userProfile.value.user?.emailId ?? "";
        addressController.text =
            "${userProfile.value.user?.addressComponent.city}, ${userProfile.value.user?.addressComponent.state} - ${userProfile.value.user?.addressComponent.pincode}";
        latitude = userProfile.value.user?.latitude;
        longitude = userProfile.value.user?.longitude;
        pincode = userProfile.value.user?.addressComponent.pincode;
        city = userProfile.value.user?.addressComponent.city;
        state = userProfile.value.user?.addressComponent.state;
      }
    } catch (e) {
      AppToasting.showError('Failed to load profile: $e');
    } finally {
      isLoading.value = false;
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

  Future<void> updateProfile() async {
    String? passengerID = AppStorage.read<String?>('passengerID');
    if (nameController.text.isEmpty || addressController.text.isEmpty) {
      AppToasting.showError("Please fill all required fields");
      return;
    }

    if (pincode == null || city == null || state == null) {
      AppToasting.showError("Location must include pincode, city, and state");
      return;
    }

    isLoading.value = true;

    final response = await profileService.editProfile({
      "passengerId": AppStorage.read('passengerID'),
      "name": nameController.text,
      "emailId": emailController.text,
      "latitude": latitude ?? "0",
      "longitude": longitude ?? "0",
      "addressComponent": {"pincode": pincode!, "city": city!, "state": state!},
      "userId": passengerID ?? "",
    });

    isLoading.value = false;

    if (response != null) {
      AppToasting.showSuccess("Profile updated successfully!");
      await fetchProfile();
      Get.offNamed(RouteName.profileScreen);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
