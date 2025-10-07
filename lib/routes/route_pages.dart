import '/routes/route_name.dart';
import '/screen/user%20profile/profile_screen.dart';
import 'package:get/get.dart';
import '../screen/auth/otp verify/otp_verify_screen.dart';
import '../screen/auth/sign_in.dart';
import '../screen/splash/splash_screen.dart';
import '../screen/home/travel_home_screen.dart';
import '../screen/auth/register/register_screen.dart';

class RoutePages {
  static final List<GetPage> pages = [
    GetPage(name: RouteName.splash, page: () => SplashScreen()),
    GetPage(name: RouteName.signIn, page: () => SignIn()),
    GetPage(name: RouteName.otpVerification, page: () => OtpVerification()),
    GetPage(name: RouteName.register, page: () => Register()),
    GetPage(name: RouteName.travelHomeScreen, page: () => TravelHomeScreen()),
    GetPage(name: RouteName.profileScreen, page: () => ProfileScreen()),
  ];
}
