import 'package:devconnect/features/auth/controller/auth_controller.dart';
import 'package:devconnect/features/auth/view/signup_view.dart';
import 'package:devconnect/features/home/view/home_view.dart';
import 'package:devconnect/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DevConnect',
      theme: AppTheme.theme,
      home: ref.watch(currentUserAccountProvider).when(
            data: (user) {
              if (user != null) {
                return HomeView();
              }
              return SignUpView();
            },
            error: (error, st) => HomeView(),
            loading: () => HomeView(),
          ),
    );
  }
}
