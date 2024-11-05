import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tms_app/db/db_helper.dart';
import 'package:tms_app/onboding/onboding_screen.dart';
import 'package:tms_app/services/theme_services.dart';
import 'package:tms_app/ui/screens/home_page.dart';
import 'package:tms_app/ui/screens/side_bar_entry/calendar.dart';
import 'package:tms_app/utils/theme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb(); // initialize the database
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, // close the debug banner
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,

      home: Calendar(),
      // home: HomePage(),
      // TODO -- When need to add the login function, uncomment this
      // home: OnbodingScreen(), // login page
    );
  }
}

