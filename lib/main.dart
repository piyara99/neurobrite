import 'package:flutter/material.dart';
import 'package:neurobrite/routes/app_routes.dart';

void main() {
  runApp(const NeuroBriteApp());
}

class NeuroBriteApp extends StatelessWidget {
  const NeuroBriteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroBrite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Sans',
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes, // 🔥 This is the key part!
    );
  }
}
