import 'package:coolie_passanger/repository/authentication_repo.dart';
import 'package:coolie_passanger/routes/route_name.dart';
import 'package:coolie_passanger/routes/route_pages.dart';
import 'package:coolie_passanger/utils/app_config.dart';
import 'package:coolie_passanger/utils/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get_storage/get_storage.dart';

void main() async{

  await GetStorage.init();
  await loadRepositories();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appName,
      initialRoute: RouteName.splash,
      getPages: RoutePages.pages,
      defaultTransition: Transition.rightToLeftWithFade,
      debugShowCheckedModeBanner: false,
      theme: defaultTheme,
    );
  }
}

Future<void> loadRepositories() async {
  await Get.putAsync(() => AuthenticationRepo().init());
  // Get.put(FeeManagementController());
}
