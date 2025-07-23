import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:neurobrite/routes/app_routes.dart';
import 'package:neurobrite/routes/slide_route.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const NeuroBriteApp());
}

class NeuroBriteApp extends StatelessWidget {
  const NeuroBriteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroBrite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) {
        final builder = AppRoutes.routes[settings.name];
        if (builder != null) {
          return SlideRoute(page: builder(context));
        }
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text("404 - Page not found")),
              ),
        );
      },
    );
  }
}
