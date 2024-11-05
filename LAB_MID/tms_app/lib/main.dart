import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_app/constant/constant_screen.dart';
import 'package:tms_app/layout/home_layout.dart';
import 'package:tms_app/cubit/app_cubit.dart'; // Import AppCubit
import 'package:tms_app/cubit/app_states.dart'; // Import AppStates if needed
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import for FFI support
import 'constant/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database factory for FFI
  databaseFactory = databaseFactoryFfi;

  await translator.init(
    localeType: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'assets/langs/',
  );

  BlocOverrides.runZoned(
        () {
      runApp(LocalizedApp(
        child: const MyApp(),
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(), // Initialize AppCubit and create the database
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData(),
        home: HomeLayout(),
        localizationsDelegates: translator.delegates, // Android + iOS Delegates
        locale: translator.locale, // Active locale
        supportedLocales: translator.locals(), // Locals list
      ),
    );
  }
}
