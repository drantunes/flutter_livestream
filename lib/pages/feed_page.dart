import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_livestream/pages/live_page.dart';
import 'package:flutter_livestream/providers/usuarios_provider.dart';
import 'package:flutter_livestream/widgets/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final double size = 27;

  startLive() {
    context.read<UsuariosProvider>().startLive();
    final host = context.read<UsuariosProvider>().usuarioLogado;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LivePage(usuario: host),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuarios = context.watch<UsuariosProvider>().usuarios;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Livegram', style: GoogleFonts.oleoScript(fontSize: size)),
        actions: [
          IconButton(
            onPressed: startLive,
            icon: const Icon(Icons.add_box_outlined),
            iconSize: size,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
            iconSize: size,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.maps_ugc_outlined),
            iconSize: size,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(top: 24, left: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Profile(usuario: usuarios[index]),
                itemCount: usuarios.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
