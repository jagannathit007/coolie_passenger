class NetworkConstants {
  // local Urls
  static const String baseUrl = 'https://hpf47sfz-2500.inc1.devtunnels.ms/';
  static const String imageURL = 'https://hpf47sfz-2500.inc1.devtunnels.ms/';

  //Production Urls

  //Endpoints

  //   Authentications
  static const String signIn = 'api/users/signIn';
  static const String signUp = 'api/users/signUp';
  static const String otpVerification = 'api/users/isVerified';
  static const String resend = 'api/users/resend-otp';
  static const String faceDetect = 'api/users/faceLogin';

  //USER
  static const String getUserProfile = 'api/users/userProfile';
  static const String editProfile = 'api/users/updateUser';
  static const String bookCoolie = 'api/users/createBooking';
  static const String getBookingStatus = 'api/users/getBookingStatus';
  static const String getBookingHistory = 'api/users/getBookingHistory';
  static const String rateBooking = 'api/users/rateBooking';
  static const String getStations = 'api/admin/getAllStation';

  // Timeouts
  static const int sendTimeout = 30000; // 30 seconds
}
