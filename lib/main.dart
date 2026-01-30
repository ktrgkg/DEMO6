import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "core/constants/app_strings.dart";
import "core/router/app_router.dart";
import "core/theme/app_theme.dart";

void main() {
  runApp(const ProviderScope(child: JobMatchingApp()));
}

class JobMatchingApp extends ConsumerWidget {
  const JobMatchingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: AppTheme.light(),
      locale: const Locale("vi"),
      supportedLocales: const [Locale("vi")],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
