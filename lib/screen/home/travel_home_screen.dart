import '/services/app_storage.dart';
import '/screen/home/travel_home_controller.dart';
import '/models/booking_models.dart'; // Import for types
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
            title: const Text("Exit App"),
            content: const Text("Do you want to close the application?"),
            actions: [
              TextButton(onPressed: () => Get.back(result: false), child: const Text("No")),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: Text("Yes", style: GoogleFonts.poppins(color: Constants.instance.instagramRed)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TravelHomeController>(
      init: TravelHomeController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            backgroundColor: const Color(0xffF5F5F4),
            appBar: AppBar(
              title: Text("Passenger Dashboard", style: TextStyle(color: Constants.instance.white)),
              backgroundColor: Constants.instance.primary,
              elevation: 4,
              iconTheme: IconThemeData(color: Constants.instance.white),
            ),
            drawer: _buildDrawer(controller),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCurrentBookingCard(controller),
                    const SizedBox(height: 20),
                    Text("Booking History", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: controller.bookingHistory.isEmpty
                          ? const Center(child: Text("No Booking History"))
                          : ListView.builder(
                              controller: controller.scrollController,
                              itemCount: controller.bookingHistory.length + (controller.hasMore.value ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == controller.bookingHistory.length && controller.hasMore.value) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                final booking = controller.bookingHistory[index];
                                return BookingHistoryCard(booking: booking);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => controller.showBookCoolieBottomSheet(context),
              icon: Icon(Icons.book, color: Constants.instance.white),
              label: Text("Book Coolie", style: TextStyle(color: Constants.instance.white)),
              backgroundColor: Constants.instance.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentBookingCard(TravelHomeController controller) {
    return Obx(() {
      final booking = controller.currentBooking.value;
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: booking == null
              ? const Center(
                  child: Text("No Coolie Booked", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Current Booking", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildBookingDetail("Booking ID", booking.bookingId),
                    _buildBookingDetail("Status", booking.status),
                    _buildBookingDetail("OTP", booking.otp.toString()),
                    _buildBookingDetail(
                      "Pickup",
                      "Platform ${booking.pickupDetails.station}, Coach ${booking.pickupDetails.coachNumber}, ${booking.pickupDetails.description}",
                    ),
                    _buildBookingDetail("Destination", booking.destination),
                    _buildBookingDetail("Booked At", booking.timestamp.bookedAt),
                    _buildBookingDetail("Accepted At", booking.timestamp.acceptedAt ?? "N/A"),
                    _buildBookingDetail("Pickup Time", booking.timestamp.pickupTime ?? "N/A"),
                    _buildBookingDetail("Completed At", booking.timestamp.completedAt ?? "N/A"),
                    _buildBookingDetail("Fare", "₹${booking.fare.totalFare}"),
                    const Divider(),
                    Text("Coolie Details", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    _buildBookingDetail("Name", booking.assignedCollie ?? booking.collieId ?? "N/A"),
                    _buildBookingDetail("Mobile", "N/A"), // Not in response; extend if needed
                    _buildBookingDetail("Rate Card", "N/A"), // Not in response; extend if needed
                  ],
                ),
        ),
      );
    });
  }

  Widget _buildBookingDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(value, style: GoogleFonts.poppins(fontSize: 14), textAlign: TextAlign.end),
          ),
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookingDetail("Booking ID", booking.bookingId),
            _buildBookingDetail("Status", booking.status),
            _buildBookingDetail(
              "Pickup",
              "Platform ${booking.pickupDetails.station}, Coach ${booking.pickupDetails.coachNumber}, ${booking.pickupDetails.description}",
            ),
            _buildBookingDetail("Destination", booking.destination),
            _buildBookingDetail("Fare", "₹${booking.fare.totalFare}"),
            _buildBookingDetail("Booked At", booking.timestamp.bookedAt),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(value, style: GoogleFonts.poppins(fontSize: 14), textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}

Widget _buildDrawer(TravelHomeController controller) {
  return Obx(() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(controller.userProfile.value.user?.name ?? "Guest", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            accountEmail: Text(controller.userProfile.value.user?.mobileNo ?? "", style: GoogleFonts.poppins()),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.grey),
            ),
            decoration: BoxDecoration(color: Constants.instance.primary),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('Profile', style: GoogleFonts.poppins()),
                  onTap: () {
                    Get.back();
                    Get.toNamed(RouteName.profileScreen);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text('Logout', style: GoogleFonts.poppins()),
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
