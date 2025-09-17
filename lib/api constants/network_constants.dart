

class NetworkConstants {
  // local Urls
    static const String baseUrl = 'https://0cv89p3x-5000.inc1.devtunnels.ms/';
  static const String imageURL = 'https://0cv89p3x-5000.inc1.devtunnels.ms/';

  //Production Urls

  //Endpoints

  //   Authentications
    static const String signIn = 'api/users/signIn';
    static const String signUp = 'api/users/signUp';
    static const String otpVerification = 'api/users/isVerified';
    static const String faceDetect = 'api/users/faceLogin';

    //USER
    static const String getUserProfile = 'api/users/userProfile';
    static const String bookCoolie = 'api/users/createBooking';

  // Timeouts
  static const int sendTimeout = 30000; // 30 seconds
}