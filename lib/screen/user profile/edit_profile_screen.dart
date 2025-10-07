import 'package:coolie_passanger/screen/user%20profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/customs/custom_form_field.dart';
import '../../utils/app_constants.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        Future<void> _getCurrentLocation() async {
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            Get.snackbar("Error", "Location services are disabled.");
            return;
          }

          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              Get.snackbar("Error", "Location permission denied.");
              return;
            }
          }

          if (permission == LocationPermission.deniedForever) {
            Get.snackbar("Error", "Location permissions are permanently denied.");
            return;
          }

          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

          List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
          Placemark place = placemarks[0];

          String fullAddress = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";

          controller.setLocation(
            fullAddress: fullAddress,
            lat: position.latitude.toString(),
            long: position.longitude.toString(),
            pincode: place.postalCode ?? "",
            city: place.locality ?? "",
            state: place.administrativeArea ?? "",
          );
        }

        void _showAvatarSheet(BuildContext context) {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
            builder: (_) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Constants.instance.primary.withOpacity(0.1),
                          child: Icon(Icons.photo_camera, color: Constants.instance.primary),
                        ),
                        title: const Text('Take Photo'),
                        onTap: () async {
                          Navigator.pop(context);
                          await controller.pickImageFromCamera();
                        },
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Constants.instance.primary.withOpacity(0.1),
                          child: Icon(Icons.photo_library, color: Constants.instance.primary),
                        ),
                        title: const Text('Choose from Gallery'),
                        onTap: () async {
                          Navigator.pop(context);
                          await controller.pickImageFromGallery();
                        },
                      ),
                      if (controller.profileImage.value != null || controller.userProfile.value.user?.userImage.isNotEmpty == true)
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            child: const Icon(Icons.delete, color: Colors.red),
                          ),
                          title: const Text('Remove Photo'),
                          onTap: () {
                            Navigator.pop(context);
                            controller.removeProfileImage();
                          },
                        ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              );
            },
          );
        }

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text("Edit Profile", style: TextStyle(color: Constants.instance.white)),
            backgroundColor: Constants.instance.primary,
            elevation: 4,
            iconTheme: IconThemeData(color: Constants.instance.white),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Constants.instance.primary.withOpacity(0.06), Constants.instance.lightSecondary.withOpacity(0.05)],
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Form(
                            key: controller.editFormKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    GestureDetector(
                                      onTap: () => _showAvatarSheet(context),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, 10))],
                                          border: Border.all(color: Constants.instance.primary.withOpacity(0.15), width: 2),
                                          image: controller.profileImage.value != null
                                              ? DecorationImage(image: FileImage(controller.profileImage.value!), fit: BoxFit.cover)
                                              : controller.userProfile.value.user?.userImage.isNotEmpty == true
                                              ? DecorationImage(image: NetworkImage(controller.userProfile.value.user!.userImage), fit: BoxFit.cover)
                                              : null,
                                        ),
                                        child: controller.profileImage.value == null && controller.userProfile.value.user?.userImage.isEmpty == true
                                            ? Icon(Icons.person, size: 40, color: theme.colorScheme.onSurface.withOpacity(0.5))
                                            : null,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: GestureDetector(
                                        onTap: () => _showAvatarSheet(context),
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: Constants.instance.primary,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 3),
                                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 10, offset: const Offset(0, 4))],
                                          ),
                                          child: const Center(child: Icon(Icons.camera_alt_outlined, size: 18, color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Update Profile',
                                  style: TextStyle(fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface, fontSize: 18),
                                ),
                                const SizedBox(height: 6),
                                Text('Edit your details', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7), fontSize: 17)),
                                const SizedBox(height: 20),
                                Card(
                                  elevation: 0,
                                  color: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(color: Colors.grey[200]!),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        CustomFormField(
                                          controller: controller.nameController,
                                          hintText: "Name",
                                          borderEnabled: true,
                                          style: const TextStyle(fontSize: 15),
                                          borderRadius: 12,
                                          hintFontSize: 14,
                                          isRequiredMark: true,
                                          textCapitalization: TextCapitalization.words,
                                        ),
                                        const SizedBox(height: 10),
                                        CustomFormField(
                                          controller: controller.emailController,
                                          hintText: "Email (Optional)",
                                          borderEnabled: true,
                                          style: const TextStyle(fontSize: 15),
                                          borderRadius: 12,
                                          hintFontSize: 14,
                                          keyboardType: TextInputType.emailAddress,
                                        ),
                                        const SizedBox(height: 10),
                                        CustomFormField(
                                          controller: controller.addressController,
                                          hintText: "Address (Auto from GPS)",
                                          borderEnabled: true,
                                          style: const TextStyle(fontSize: 15),
                                          borderRadius: 12,
                                          hintFontSize: 14,
                                          isRequiredMark: true,
                                          readOnly: true,
                                          suffix: IconButton(
                                            onPressed: _getCurrentLocation,
                                            icon: Icon(Icons.location_pin, color: Constants.instance.primary),
                                          ),
                                        ),
                                        const SizedBox(height: 18),
                                        AnimatedScale(
                                          scale: controller.isLoading.value ? 0.98 : 1,
                                          duration: const Duration(milliseconds: 180),
                                          child: ElevatedButton(
                                            onPressed: controller.isLoading.value
                                                ? null
                                                : () {
                                                    controller.updateProfile();
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Constants.instance.primary,
                                              minimumSize: const Size(double.infinity, 20),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                            child: controller.isLoading.value
                                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                                : Text(
                                                    'Save Changes',
                                                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
