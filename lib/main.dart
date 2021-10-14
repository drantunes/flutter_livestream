import 'package:flutter/material.dart';
import 'package:flutter_livestream/pages/login_page.dart';
import 'package:flutter_livestream/providers/live_provider.dart';
import 'package:flutter_livestream/providers/usuarios_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UsuariosProvider>(
          create: (_) => UsuariosProvider(),
        ),
        ChangeNotifierProvider<LiveProvider>(
          create: (_) => LiveProvider(),
        ),
      ],
      child: const App(),
    ),
  );
}

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryBlack,
      ),
      home: const LoginPage(),
    );
  }
}
