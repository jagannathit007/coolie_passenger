import 'package:coolie_passanger/screen/user%20profile/edit_profile_screen.dart';
import 'package:coolie_passanger/screen/user%20profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/route_name.dart';
import '../../utils/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text("My Profile", style: TextStyle(color: Constants.instance.white)),
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
                      : controller.userProfile.value.user == null
                      ? const Center(child: Text("Failed to load profile"))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, 10))],
                                      border: Border.all(color: Constants.instance.primary.withOpacity(0.15), width: 2),
                                      image: controller.userProfile.value.user!.userImage.isNotEmpty
                                          ? DecorationImage(image: NetworkImage(controller.userProfile.value.user!.userImage), fit: BoxFit.cover)
                                          : null,
                                    ),
                                    child: controller.userProfile.value.user!.userImage.isEmpty
                                        ? Icon(Icons.person, size: 40, color: theme.colorScheme.onSurface.withOpacity(0.5))
                                        : null,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                controller.userProfile.value.user!.name,
                                style: TextStyle(fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface, fontSize: 18),
                              ),
                              const SizedBox(height: 6),
                              Text("Passenger", style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7), fontSize: 17)),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildProfileDetail("Mobile No.", controller.userProfile.value.user!.mobileNo, Icons.phone),
                                      const SizedBox(height: 12),
                                      _buildProfileDetail(
                                        "Email",
                                        controller.userProfile.value.user!.emailId.isEmpty ? "Not Provided" : controller.userProfile.value.user!.emailId,
                                        Icons.email,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildProfileDetail(
                                        "Address",
                                        "${controller.userProfile.value.user!.addressComponent.city}, ${controller.userProfile.value.user!.addressComponent.state} - ${controller.userProfile.value.user!.addressComponent.pincode}",
                                        Icons.location_on,
                                      ),
                                      const SizedBox(height: 18),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Get.to(EditProfileScreen());
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Constants.instance.primary,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                          ),
                                          child: Text(
                                            "Edit Profile",
                                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            controller.deleteAccount(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Constants.instance.primary,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                          ),
                                          child: Text(
                                            "Delete Account",
                                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
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
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileDetail(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Constants.instance.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
              Text(value, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}
