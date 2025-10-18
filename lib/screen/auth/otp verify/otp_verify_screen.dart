import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/customs/custom_rich_text.dart';
import '../../../services/customs/otp_verification.dart';
import '../../../utils/app_constants.dart';
import 'otp_verify_controller.dart';

class OtpVerification extends StatelessWidget {
  const OtpVerification({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<OtpVerifyController>(
      init: OtpVerifyController(),
      builder: (controller) {
        return Scaffold(
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
                        colors: [Constants.instance.primary.withOpacity(0.06), Constants.instance.lightSecondary.withOpacity(0.05)],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, 10))],
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
                          'OTP Verification',
                          style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w700, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Enter the 4-digit OTP sent to your Mobile Number',
                          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7), fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
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
                                SizedBox(height: 25),
                                PinCodeTextField(
                                  highlight: true,
                                  maxLength: 4,
                                  pinBoxWidth: 45,
                                  pinBoxHeight: 45,
                                  pinBoxRadius: 10,
                                  pinBoxBorderWidth: 0.75,
                                  wrapAlignment: WrapAlignment.center,
                                  highlightPinBoxColor: Colors.white,
                                  highlightColor: Constants.instance.primary,
                                  defaultBorderColor: Colors.grey.shade400,
                                  keyboardType: TextInputType.number,
                                  pinTextStyle: TextStyle(fontSize: 16),
                                  pinBoxOuterPadding: const EdgeInsets.symmetric(horizontal: 6),
                                  pinBoxColor: Colors.transparent,
                                  errorBorderColor: Colors.redAccent,
                                  hasTextBorderColor: Colors.black,
                                  controller: controller.verificationCodeController,
                                ),
                                const SizedBox(height: 20),
                                Obx(
                                  () => AnimatedScale(
                                    scale: controller.isLoading.value ? 0.98 : 1.0,
                                    duration: const Duration(milliseconds: 180),
                                    child: ElevatedButton(
                                      onPressed: controller.isLoading.value
                                          ? null
                                          : () async {
                                              await controller.verifyOtp();
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Constants.instance.primary,
                                        minimumSize: const Size(double.infinity, 20),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      child: controller.isLoading.value
                                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                          : Text(
                                              'Verify',
                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () => CustomRichText(
                            text1: controller.isResendEnabled.value ? 'Didn\'t receive the OTP?  ' : 'Resend OTP in ${controller.countdown.value}s  ',
                            text2: controller.isResendEnabled.value ? 'Resend OTP' : '',
                            style1: TextStyle(fontSize: 15, color: Colors.grey.shade900),
                            style2: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: controller.isResendEnabled.value ? Constants.instance.primary : Colors.grey,
                            ),
                            onTap2: controller.isResendEnabled.value ? controller.resendOtp : null,
                            textAlign: TextAlign.center,
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
