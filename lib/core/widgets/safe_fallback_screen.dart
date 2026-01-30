import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../constants/app_routes.dart";

class SafeFallbackScreen extends StatelessWidget {
  const SafeFallbackScreen({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông báo")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 40),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text("Về trang chủ"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
