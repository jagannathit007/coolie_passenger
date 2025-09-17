import 'package:coolie_passanger/models/get_user_profile_model.dart';
import 'package:coolie_passanger/repository/authentication_repo.dart';
import 'package:coolie_passanger/services/app_storage.dart';
import 'package:coolie_passanger/utils/app_constants.dart';
import 'package:coolie_passanger/widgets/text_box_widegt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../services/app_toasting.dart';

class TravelHomeController extends GetxController {
  late Razorpay _razorpay;
  final passengerId=''.obs;
  final isLoading=false.obs;
  Rx<GetUserProfile> userProfile = GetUserProfile().obs;
  final AuthenticationRepo authenticationRepo = AuthenticationRepo();

  final stationController = TextEditingController();
  final TextEditingController coachNoController =TextEditingController();
  final TextEditingController destinationController =TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    passengerId.value = AppStorage.read('passengerID');
    debugPrint("Id== ${passengerId.value}");
    getAPICalling();
  }

  void openCheckout(double amount) {
    var options = {
      'key': 'rzp_test_huTmioKmO2Z4SA',
      'amount': (amount * 100).toInt(), // paise
      'name': 'Coolie Booking',
      'description': 'Payment for Coolie Service',
      'prefill': {'contact': '9876543210', 'email': 'testuser@gmail.com'},
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    AppToasting.showSuccess(
      "Payment Successful Payment ID: ${response.paymentId}",
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    AppToasting.showError("Payment Failed response.message ?? Unknown Error");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("External Wallet", response.walletName ?? "");
  }



  void bookCoolieDetails() {
    Get.dialog(
      AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Book Coolie", style: GoogleFonts.poppins(fontSize: 15)),
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.close, color: Colors.redAccent),
            ),
          ],
        ),
        content: SizedBox(
          height: 300,
          child: Column(children: [
            TextBoxWidget(
              controller: stationController,
              hintText: "Station",
            ),SizedBox(height: 10,),
            TextBoxWidget(
              controller: destinationController,
              hintText: "Destination",
            ),SizedBox(height: 10,),
            TextBoxWidget(
              controller: coachNoController,
              hintText: "Coach Number",
            ),
            SizedBox(height: 30,),
            MaterialButton(onPressed: (){
              bookCoolie();
              Get.back();
              stationController.text='';
              destinationController.text='';
              coachNoController.text='';
            },
            height: 40,
            minWidth: 120,
              color: Constants.instance.primary,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(color: Constants.instance.primary)
              ),
              child: Text("BOOK", style: GoogleFonts.poppins(color: Constants.instance.white),),
            ),


          ]),
        ),
      ),
    );
  }

  Future<void>bookCoolie()async{
    isLoading.value=true;
    try{
      final request={
        "passengerId":passengerId.value,
        "coachNumber":coachNoController.text.trim(),
        "station":stationController.text.trim(),
        "destination":destinationController.text.trim(),
      };
      final result= await authenticationRepo.bookCoolie(request);

      if(result !=null){
        AppToasting.showSuccess( 'successfully');
      }
    }catch(e){
    debugPrint("ERROR in Book Coolie");
    isLoading.value=false;
    }finally{
      isLoading.value=false;
    }

  }


  Future<void> getAPICalling() async {
    try {
      isLoading.value = true;
      final response = await authenticationRepo.myProfile();
      debugPrint("MODEL ${response}");
      userProfile.value = GetUserProfile.fromJson(response);
      debugPrint("userProfile.value ${userProfile.value.toJson()}");
      // if (response != null) {
      //
      //   // initializeControllers();
      // }
    } catch (e) {
      AppToasting.showError('Failed to load profile: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }
}
