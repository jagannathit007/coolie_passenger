import 'dart:developer';

import '../../widgets/text_box_widegt.dart';
import '/screen/home/travel_home_service.dart';
import '/screen/user%20profile/profile_service.dart';
import '/models/get_user_profile_model.dart';
import '/models/booking_models.dart';
import '/services/app_storage.dart';
import '/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../services/app_toasting.dart';

class TravelHomeController extends GetxController {
  // late Razorpay _razorpay;
  final passengerId = ''.obs;
  final isLoading = false.obs;
  Rx<GetUserProfile> userProfile = GetUserProfile().obs;
  late final TravelHomeService travelHomeService;
  late final ProfileService profileService;
  final stationController = TextEditingController();
  final platformController = TextEditingController();
  final coachNoController = TextEditingController();
  final descriptionController = TextEditingController();
  final destinationController = TextEditingController();
  final selectedStation = Rxn<String>();
  final stations = <dynamic>[].obs;
  final currentBooking = Rxn<Booking>();
  final bookingHistory = <Booking>[].obs;
  final page = 1.obs;
  final hasMore = true.obs;
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    passengerId.value = AppStorage.read('passengerID') ?? '';
    log("Passenger ID: ${passengerId.value}");
    _fetchInitialData();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && hasMore.value) {
        fetchBookingHistory();
      }
    });
  }

  void _initializeServices() {
    try {
      travelHomeService = Get.find<TravelHomeService>();
    } catch (e) {
      travelHomeService = Get.put(TravelHomeService());
    }
    try {
      profileService = Get.find<ProfileService>();
    } catch (e) {
      profileService = Get.put(ProfileService());
    }
  }

  Future<void> _fetchInitialData() async {
    isLoading.value = true;

    try {
      await getAPICalling();
      if (userProfile.value.user == null) {
        throw Exception("Failed to fetch user profile");
      }
      await fetchStations();
      if (stations.isEmpty) {
        throw Exception("No stations found");
      }
      await fetchCurrentBooking();
      await fetchBookingHistory();
    } catch (e) {
      log("Error in initial data fetch: $e");
      AppToasting.showError('Failed to load initial data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStations() async {
    try {
      final response = await travelHomeService.getStations();
      if (response != null && response['station'] != null) {
        stations.value = response['station'];
        log("Stations fetched: ${stations.length}");
      } else {
        AppToasting.showWarning('No stations found');
      }
    } catch (e) {
      log("Error fetching stations: $e");
      AppToasting.showError('Failed to load stations: $e');
    }
  }

  Future<void> fetchCurrentBooking() async {
    try {
      final response = await travelHomeService.getBookingStatus(passengerId: passengerId.value);
      log("Booking Status Response: $response");
      if (response != null && response is Map<String, dynamic>) {
        currentBooking.value = Booking.fromJson(response);
        log("Current Booking: ${currentBooking.value?.toJson()}");
      } else {
        currentBooking.value = null;
        log("No current booking found");
      }
    } catch (e) {
      log("Error fetching booking status: $e");
      AppToasting.showError('Failed to load booking status: $e');
    }
  }

  Future<void> fetchBookingHistory() async {
    try {
      isLoading.value = true;

      final response = await travelHomeService.getBookingHistory(passengerId: passengerId.value, page: page.value);

      log("Booking History Parsed: ${response?.docs.length}");

      if (response != null && response.docs.isNotEmpty) {
        bookingHistory.addAll(response.docs);
        page.value++;
        hasMore.value = response.hasNextPage;
        log("Booking History Count: ${bookingHistory.length}, Has More: ${hasMore.value}");
      } else {
        hasMore.value = false;
        if (page.value == 1) {
          log("No booking history found");
          bookingHistory.clear();
        }
      }
    } catch (e) {
      log("Error fetching booking history: $e");
      AppToasting.showError('Failed to load booking history: $e');
      hasMore.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void openCheckout(double amount) {
    var options = {
      'key': 'rzp_test_huTmioKmO2Z4SA',
      'amount': (amount * 100).toInt(),
      'name': 'Coolie Booking',
      'description': 'Payment for Coolie Service',
      'prefill': {'contact': '9876543210', 'email': 'testuser@gmail.com'},
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      // _razorpay.open(options);
    } catch (e) {
      log("Payment Error: $e");
    }
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   AppToasting.showSuccess("Payment Successful Payment ID: ${response.paymentId}");
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   AppToasting.showError("Payment Failed: ${response.message ?? 'Unknown Error'}");
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   Get.snackbar("External Wallet", response.walletName ?? "");
  // }

  void showBookCoolieBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (_, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(height: 20),
                  Text("Book Coolie", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Select Station",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      value: selectedStation.value,
                      items: stations.map((station) {
                        return DropdownMenuItem<String>(value: station['_id'] as String, child: Text(station['name'] as String));
                      }).toList(),
                      onChanged: (value) => selectedStation.value = value,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextBoxWidget(controller: platformController, hintText: "Platform Number"),
                  const SizedBox(height: 16),
                  TextBoxWidget(controller: coachNoController, hintText: "Coach Number (Optional)"),
                  const SizedBox(height: 16),
                  TextBoxWidget(controller: descriptionController, hintText: "Description"),
                  const SizedBox(height: 16),
                  TextBoxWidget(controller: destinationController, hintText: "Drop Point"),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.instance.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        bookCoolie();
                        Get.back();
                        platformController.clear();
                        coachNoController.clear();
                        descriptionController.clear();
                        destinationController.clear();
                      },
                      child: Text(
                        "Book Now",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> bookCoolie() async {
    if (selectedStation.value == null || platformController.text.trim().isEmpty) {
      AppToasting.showWarning("Please select a station and enter platform number");
      return;
    }
    isLoading.value = true;

    try {
      final request = {
        "passengerId": passengerId.value,
        "stationId": selectedStation.value,
        "station": platformController.text.trim(),
        "coachNumber": coachNoController.text.trim(),
        "description": descriptionController.text.trim(),
        "destination": destinationController.text.trim(),
      };
      final result = await travelHomeService.bookCoolie(request);
      if (result != null) {
        AppToasting.showSuccess('Coolie booked successfully');
        currentBooking.value = null; // Reset to trigger refresh
        await fetchCurrentBooking();
        bookingHistory.clear();
        page.value = 1;
        hasMore.value = true;
        await fetchBookingHistory();
      }
    } catch (e) {
      log("ERROR in Book Coolie: $e");
      AppToasting.showError('Failed to book coolie: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAPICalling() async {
    try {
      final response = await profileService.myProfile();
      log("Profile Response: $response");
      userProfile.value = GetUserProfile.fromJson(response);
      log("User Profile: ${userProfile.value.toJson()}");
    } catch (e) {
      log("Error fetching profile: $e");
      AppToasting.showError('Failed to load profile: $e');
    }
  }

  @override
  void onClose() {
    // _razorpay.clear();
    scrollController.dispose();
    stationController.dispose();
    platformController.dispose();
    coachNoController.dispose();
    descriptionController.dispose();
    destinationController.dispose();
    super.onClose();
  }
}
