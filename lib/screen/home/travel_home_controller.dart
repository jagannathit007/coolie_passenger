import 'dart:developer';

import 'package:flutter/services.dart';

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
    final selectedPlatform = Rxn<String>();
  final selectedDropPoint = Rxn<String>();
  final stations = <dynamic>[].obs;
  final platforms = <String>['1', '2', '3', '4', '5', '6'].obs;
  final dropPoints = <String>['1', '2', '3', '4', '5', '6', 'Exit'].obs;
  final currentBooking = Rxn<Booking>();
  final bookingHistory = <Booking>[].obs;
  final page = 1.obs;
  final hasMore = true.obs;
  final scrollController = ScrollController();
  // Add FocusNode to track keyboard focus
  final focusNode = FocusNode();
  final isKeyboardVisible = false.obs;

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
    fetchInitialData();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && hasMore.value) {
        fetchBookingHistory();
      }
    });
    focusNode.addListener(() {
      isKeyboardVisible.value = focusNode.hasFocus;
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

  Future<void> fetchInitialData() async {
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
      // AppToasting.showError('Failed to load initial data: $e');
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
      // AppToasting.showError('Failed to load stations: $e');
    }
  }

  Future<void> fetchPlatforms(String stationId) async {
    try {
      final response = await travelHomeService.getAllPlatforms(stationId);
      platforms.value = response;
      dropPoints.value = response.map((platform) => 'Platform $platform').toList()..add('Exit');
      log("Platforms fetched: ${platforms.length}");
    } catch (e) {
      log("Error fetching platforms: $e");
      platforms.value = ['1', '2', '3', '4', '5', '6'];
      dropPoints.value = ['Platform 1', 'Platform 2', 'Platform 3', 'Platform 4', 'Platform 5', 'Platform 6', 'Exit'];
    }
  }

  Future<void> fetchCurrentBooking() async {
    isLoading.value = true;

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
      // AppToasting.showError('Failed to load booking status: $e');
    } finally {
      isLoading.value = false;
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
      // AppToasting.showError('Failed to load booking history: $e');
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
        return Obx(
          () => DraggableScrollableSheet(
            expand: false,
            initialChildSize: isKeyboardVisible.value ? 0.9 : 0.9,
            maxChildSize: isKeyboardVisible.value ? 0.9 : 0.9,
            minChildSize: 0.4,
            builder: (_, scrollController) => SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: MediaQuery.of(context).viewInsets.bottom + 20.0),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(height: 10),
                    Text("Book Coolie", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: DropdownMenu<String>(
                          width: MediaQuery.of(context).size.width - 40,
                          initialSelection: selectedStation.value,
                          requestFocusOnTap: false,
                          enableFilter: false,
                          enableSearch: false,
                          dropdownMenuEntries: stations.map<DropdownMenuEntry<String>>((station) {
                            return DropdownMenuEntry<String>(
                              value: station['_id'] as String,
                              label: station['name'] as String,
                              style: MenuItemButton.styleFrom(textStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
                            );
                          }).toList(),
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: Colors.grey[50],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Constants.instance.primary, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Constants.instance.primary.withOpacity(0.5), width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Constants.instance.primary, width: 2),
                            ),
                            labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
                            hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                          ),
                          label: Text('Select Station', style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54)),
                          hintText: 'Choose a station',
                          onSelected: (String? value) {
                            selectedStation.value = value;
                          },
                          menuStyle: MenuStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.white),
                            elevation: WidgetStateProperty.all(4),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: DropdownMenu<String>(
                          width: MediaQuery.of(context).size.width - 40,
                          initialSelection: selectedPlatform.value,
                          requestFocusOnTap: false,
                          enableFilter: false,
                          enableSearch: false,
                          dropdownMenuEntries: platforms.map<DropdownMenuEntry<String>>((platform) {
                            return DropdownMenuEntry<String>(
                              value: platform,
                              label: platform,
                              style: MenuItemButton.styleFrom(textStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
                            );
                          }).toList(),
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: Colors.grey[50],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Constants.instance.primary, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Constants.instance.primary.withOpacity(0.5), width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Constants.instance.primary, width: 2),
                            ),
                            labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
                            hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                          ),
                          label: Text('Pickup Platform Number', style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54)),
                          hintText: 'Choose a platform',
                          onSelected: (String? value) {
                            selectedPlatform.value = value;
                          },
                          menuStyle: MenuStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.white),
                            elevation: WidgetStateProperty.all(4),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextBoxWidget(
                      controller: coachNoController,
                      hintText: "Coach Number (Optional)",
                      labelText: "Coach Number (Optional)",
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextBoxWidget(
                      controller: descriptionController,
                      hintText: "Message",
                      labelText: "Message",
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: DropdownMenu<String>(
                          width: MediaQuery.of(context).size.width - 40,
                          initialSelection: selectedDropPoint.value,
                          requestFocusOnTap: false,
                          enableFilter: false,
                          enableSearch: false,
                          dropdownMenuEntries: dropPoints.map<DropdownMenuEntry<String>>((point) {
                            return DropdownMenuEntry<String>(
                              value: point,
                              label: point,
                              style: MenuItemButton.styleFrom(textStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
                            );
                          }).toList(),
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: Colors.grey[50],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Constants.instance.primary, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Constants.instance.primary.withOpacity(0.5), width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Constants.instance.primary, width: 2),
                            ),
                            labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
                            hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                          ),
                          label: Text('Drop Point', style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54)),
                          hintText: 'Choose a drop point',
                          onSelected: (String? value) {
                            selectedDropPoint.value = value;
                          },
                          menuStyle: MenuStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.white),
                            elevation: WidgetStateProperty.all(4),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.instance.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () async{
                          Get.back();
                          await bookCoolie();
                          platformController.clear();
                          coachNoController.clear();
                          descriptionController.clear();
                          destinationController.clear();
                          selectedStation.value = null;
                          selectedPlatform.value = null;
                          selectedDropPoint.value = null;
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
          ),
        );
      },
    );
  }

  Future<void> bookCoolie() async {
    isLoading.value = true;
    if (selectedStation.value == null || selectedPlatform.value == null || selectedDropPoint.value == null) {
      AppToasting.showWarning("Please select a station, platform number, and drop point");
      return;
    }

    try {
      final request = {
        "passengerId": passengerId.value,
        "stationId": selectedStation.value,
        "station": selectedPlatform.value,
        "coachNumber": coachNoController.text.trim(),
        "description": descriptionController.text.trim(),
        "destination": selectedDropPoint.value,
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
      // AppToasting.showError('Failed to book coolie: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAPICalling() async {
    isLoading.value = true;

    try {
      final response = await profileService.myProfile();
      log("Profile Response: $response");
      userProfile.value = GetUserProfile.fromJson(response);
      log("User Profile: ${userProfile.value.toJson()}");
    } catch (e) {
      log("Error fetching profile: $e");
      // AppToasting.showError('Failed to load profile: $e');
    } finally {
    isLoading.value = false;
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      isLoading.value = true;

      final response = await travelHomeService.cancelBooking(bookingId);

      Get.back();

      if (response != null) {
        AppToasting.showSuccess('Booking canceled successfully');

        currentBooking.value = null;
        await fetchCurrentBooking();

        bookingHistory.clear();
        page.value = 1;
        hasMore.value = true;
        await fetchBookingHistory();
      }
    } catch (e) {
      log("ERROR in Cancel Booking: $e");
    } finally {
      isLoading.value = false;
      update();
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
