class NetworkConstants {
  // local Urls
  static const String baseUrl = 'https://coolie.itfuturz.in/';
  static const String imageURL = 'https://coolie.itfuturz.in/';

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
  static const String cancelBooking = 'api/users/cancelBookingByUser';
  static const String getBookingStatus = 'api/users/getBookingStatus';
  static const String getBookingHistory = 'api/users/getBookingHistory';
  static const String rateBooking = 'api/users/rateBooking';
  static const String getStations = 'api/admin/getAllStation';
  static const String getPlatforms = 'api/admin/getPlatforms';

  // Timeouts
  static const int sendTimeout = 30000; // 30 seconds
}
