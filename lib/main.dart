import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutte_test/route/index.dart' as routeConfig;

final GoRouter _goRoute = GoRouter(
    initialLocation: '/home',
    routes: routeConfig.routes
);


void main() {
  runApp(
    MaterialApp.router(
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromRGBO(239, 239, 239, 1.0),
        textTheme: const TextTheme(bodyMedium: TextStyle(fontFamily: "pingFang-bold", fontSize: 16)),
      ),
      routerConfig: _goRoute,
    ),
  );
}
