import '/routes/route_name.dart';
import '/screen/auth/sign_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/customs/custom_rich_text.dart';
import '../../utils/app_constants.dart';
import '../../widgets/text_box_widegt.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<SignController>(
      init: SignController(),
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Constants.instance.primary.withOpacity(0.06),
                          Constants.instance.lightSecondary.withOpacity(0.05),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: Image.asset(
                                "assets/logo.png",
                                height: 70,
                                width: 70,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Book Coolie",
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Sign in to continue",
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 22),
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
                                Text(
                                  "Mobile No.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                TextBoxWidget(
                                  controller: controller.mobileController,
                                  maxLength: 10,
                                  hintText: 'Enter Mobile Number',
                                  keyboardType: TextInputType.phone,
                                  prefixIcon: Icon(
                                    Icons.call,
                                    color: Constants.instance.primary,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Mobile Number';
                                    }
                                    if (!value.isPhoneNumber) {
                                      return 'Invalid Number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),
                                Obx(
                                  () => AnimatedScale(
                                    scale: controller.isLoading.value
                                        ? 0.98
                                        : 1.0,
                                    duration: const Duration(milliseconds: 180),
                                    child: ElevatedButton(
                                      onPressed: controller.isLoading.value
                                          ? null
                                          : () async {
                                              await controller.signIn();
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Constants.instance.primary,
                                        minimumSize: Size(double.infinity, 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: controller.isLoading.value
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                          : Text(
                                              "Sign In",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: CustomRichText(
                            style1: TextStyle(fontSize: 14),
                            style2: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                            text1: "Don't you have an account  ",
                            text2: 'Sign Up Here',
                            onTap2: () {
                              Get.toNamed(RouteName.register);
                            },
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
}
