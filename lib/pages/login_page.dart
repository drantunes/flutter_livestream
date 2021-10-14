import 'package:flutter/material.dart';
import 'package:flutter_livestream/models/usuario.dart';
import 'package:flutter_livestream/pages/feed_page.dart';
import 'package:flutter_livestream/providers/usuarios_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();

  final _username = TextEditingController();

  logar() async {
    if (_form.currentState!.validate()) {
      final username = _username.text;
      final avatar = "https://robohash.org/$username.png?set=set3";
      final usuario = Usuario(username: username, avatar: avatar);
      context.read<UsuariosProvider>()
        ..login(usuario)
        ..join(usuario);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FeedPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Livegram',
                style: GoogleFonts.oleoScript(
                  fontSize: 45,
                ),
              ),
            ),
            Form(
              key: _form,
              child: TextFormField(
                controller: _username,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Seu usuário',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe seu usuário para entrar';
                  }
                  return null;
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                ),
                onPressed: logar,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.account_box),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Entrar',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
