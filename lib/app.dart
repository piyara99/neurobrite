import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'core/themes/app_theme.dart';

class NeuroBriteApp extends StatelessWidget {
  const NeuroBriteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroBrite',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
