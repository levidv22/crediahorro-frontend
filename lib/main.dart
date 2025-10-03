import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/constants/app_text_styles.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const CrediAhorroApp());
}

class CrediAhorroApp extends StatelessWidget {
  const CrediAhorroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CrediAhorro",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          titleTextStyle: AppTextStyles.brandName.copyWith(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // español
        Locale('en', 'US'), // inglés
      ],

      initialRoute: AppRouter.login,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
