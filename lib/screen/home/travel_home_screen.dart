import 'package:coolie_passanger/services/app_toasting.dart';
import 'package:coolie_passanger/services/helper.dart';

import '/services/app_storage.dart';
import '/screen/home/travel_home_controller.dart';
import '/models/booking_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/route_name.dart';
import '../../utils/app_constants.dart';

class TravelHomeScreen extends StatelessWidget {
  const TravelHomeScreen({super.key});

  Future<bool> _onWillPop() async {
    return await Get.dialog<bool>(
          AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text("Exit App", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            content: Text("Do you want to close the application?", style: GoogleFonts.poppins()),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey[700])),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.instance.instagramRed,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Exit", style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GetBuilder<TravelHomeController>(
        init: TravelHomeController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: Text(
                "Dashboard",
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
              ),
              backgroundColor: Constants.instance.primary,
              elevation: 0,
              iconTheme: IconThemeData(color: Constants.instance.white),
              // actions: [IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {})],
            ),
            drawer: _buildDrawer(controller),
            body: RefreshIndicator(
              onRefresh: () async {
                await controller.fetchCurrentBooking();
                controller.bookingHistory.clear();
                controller.page.value = 1;
                controller.hasMore.value = true;
                await controller.fetchBookingHistory();
              },
              child: Obx(
                () => controller.isLoading.value && controller.bookingHistory.isEmpty && controller.currentBooking.value == null
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(controller),
                            _buildCurrentBookingCard(controller),
                            const SizedBox(height: 24),
                            _buildBookingHistorySection(controller),
                          ],
                        ),
                      ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                if (controller.currentBooking.value != null && controller.currentBooking.value?.status == "pending" ||
                    controller.currentBooking.value?.status == "accepted") {
                  AppToasting.showWarning("You have already booked coolie");
                } else {
                  controller.showBookCoolieBottomSheet(context);
                }
              },
              icon: const Icon(Icons.add_circle_outline, size: 24),
              label: Text("Book Coolie", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
              backgroundColor:
                  controller.currentBooking.value != null && controller.currentBooking.value?.status == "pending" ||
                      controller.currentBooking.value?.status == "accepted"
                  ? Constants.instance.greyShade500
                  : Constants.instance.primary,
              foregroundColor: Colors.white,
              elevation: 6,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(TravelHomeController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Constants.instance.primary,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Obx(() {
          final name = controller.userProfile.value.user?.name ?? "Guest";
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome back,", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                name,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCurrentBookingCard(TravelHomeController controller) {
    return Obx(() {
      final booking = controller.currentBooking.value;

      if (booking == null) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue[50]!, Colors.purple[50]!], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue[100]!, width: 1),
            ),
            child: Column(
              children: [
                Icon(Icons.luggage, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 12),
                Text(
                  "No Active Booking",
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text("Book a coolie to get started", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
              ],
            ),
          ),
        );
      }

      final isPending = booking.status.toLowerCase() == 'pending';

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Constants.instance.white, Constants.instance.white.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Constants.instance.grey100.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Constants.instance.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.check_circle, color: Constants.instance.primary, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Active Booking",
                                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(color: _getStatusColor(booking.status), borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  booking.status.capitalizeFirst ?? booking.status,
                                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    _buildInfoRow(Icons.qr_code_2, "Booking ID", booking.bookingId),
                    const SizedBox(height: 20),
                    _buildInfoRow(Icons.pin, "OTP", booking.otp.toString(), isHighlight: true),
                  ],
                ),
              ),
              Divider(height: 10),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildWhiteInfoRow(
                      Icons.location_on_outlined,
                      "Pickup Location",
                      "Platform ${booking.pickupDetails.station ?? 'N/A'}, Coach ${booking.pickupDetails.coachNumber ?? 'N/A'}",
                    ),
                    const SizedBox(height: 12),
                    _buildWhiteInfoRow(Icons.my_location_outlined, "Destination", booking.destination),
                    const SizedBox(height: 12),
                    _buildWhiteInfoRow(Icons.currency_rupee, "Fare", "₹${booking.collie?.rateCard.baseRate}"),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Colors.grey, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Assigned Coolie", style: GoogleFonts.poppins(fontSize: 12, color: Constants.instance.black)),
                                const SizedBox(height: 4),
                                Text(
                                  booking.assignedCollie ?? booking.collie!.name,
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Constants.instance.black),
                                ),
                                if (booking.collie!.mobileNo.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    booking.collie!.mobileNo,
                                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Constants.instance.black),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Call Button
                          if (booking.collie!.mobileNo.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                helper.makePhoneCall(booking.collie!.mobileNo);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.phone, color: Colors.white, size: 24),
                              ),
                            ),
                        ],
                      ),
                    ),

                    if (isPending) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Colors.red, Color(0xFFE53935)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _showCancelBookingDialog(controller, booking.id);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.cancel_outlined, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Cancel Booking",
                                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showCancelBookingDialog(TravelHomeController controller, String bookingId) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
            ),
            const SizedBox(width: 12),
            Text("Cancel Booking", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Are you sure you want to cancel this booking?", style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[700])),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text("This action cannot be undone", style: GoogleFonts.poppins(fontSize: 12, color: Colors.orange[800])),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "No, Keep It",
              style: GoogleFonts.poppins(color: Colors.grey[700], fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.red, Color(0xFFE53935)]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                controller.cancelBooking(bookingId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Yes, Cancel",
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isHighlight = false}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Constants.instance.primary),
        const SizedBox(width: 12),
        Text("$label: ", style: GoogleFonts.poppins(fontSize: 14, color: Constants.instance.black)),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isHighlight ? 18 : 14,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
              color: isHighlight ? Constants.instance.primary : Constants.instance.black,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildWhiteInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Constants.instance.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.poppins(fontSize: 14, color: Constants.instance.black)),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Constants.instance.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'accepted':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildBookingHistorySection(TravelHomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, size: 24, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(
                "Booking History",
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.bookingHistory.isEmpty && !controller.isLoading.value) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text("No Booking History", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600])),
                  ],
                ),
              );
            }

            return ListView.builder(
              controller: controller.scrollController,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.bookingHistory.length + (controller.hasMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.bookingHistory.length && controller.hasMore.value) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final booking = controller.bookingHistory[index];
                return BookingHistoryCard(booking: booking);
              },
            );
          }),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class BookingHistoryCard extends StatelessWidget {
  final Booking booking;

  const BookingHistoryCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.bookingId,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[800]),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getStatusColor(booking.status), width: 1),
                  ),
                  child: Text(
                    booking.status.capitalizeFirst ?? booking.status,
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: _getStatusColor(booking.status)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _buildHistoryDetail(
              Icons.location_on_outlined,
              "Platform ${booking.pickupDetails.station ?? 'N/A'}, Coach ${booking.pickupDetails.coachNumber ?? 'N/A'}",
            ),
            const SizedBox(height: 8),
            _buildHistoryDetail(Icons.my_location_outlined, booking.destination),
            const SizedBox(height: 8),
            Row(
              children: [
                Flexible(child: _buildHistoryDetail(Icons.calendar_today_outlined, booking.timestamp.bookedAt, isSmall: true)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Constants.instance.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(Icons.currency_rupee, size: 16, color: Constants.instance.primary),
                      Text(
                        (booking.fare.totalFare).toString(),
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Constants.instance.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryDetail(IconData icon, String value, {bool isSmall = false}) {
    return Row(
      children: [
        Icon(icon, size: isSmall ? 14 : 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(fontSize: isSmall ? 12 : 14, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'accepted':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

Widget _buildDrawer(TravelHomeController controller) {
  return Obx(() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Constants.instance.primary, Constants.instance.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: const CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  controller.userProfile.value.user?.name ?? "Guest",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(controller.userProfile.value.user?.mobileNo ?? "", style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ListTile(
                  leading: Icon(Icons.person_outline, color: Constants.instance.primary),
                  title: Text('My Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Get.back();
                    Get.toNamed(RouteName.profileScreen);
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.history, color: Constants.instance.primary),
                //   title: Text('Booking History', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                //   trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                //   onTap: () {
                //     Get.back();
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.support_agent_outlined, color: Constants.instance.primary),
                //   title: Text('Help & Support', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                //   trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                //   onTap: () {
                //     Get.back();
                //   },
                // ),
                const Divider(height: 32),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    'Logout',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.red),
                  ),
                  onTap: () async {
                    await AppStorage.clearAll();
                    Get.offAllNamed(RouteName.signIn);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  });
}
