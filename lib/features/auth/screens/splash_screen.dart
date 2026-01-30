import "package:flutter/material.dart";

import "../../../core/constants/app_strings.dart";

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(AppStrings.splashTitle),
          ],
        ),
      ),
    );
  }
}
