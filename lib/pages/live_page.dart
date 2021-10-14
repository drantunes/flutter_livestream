import 'package:flutter/material.dart';
import 'package:flutter_livestream/main.dart';
import 'package:flutter_livestream/models/usuario.dart';
import 'package:flutter_livestream/providers/live_provider.dart';
import 'package:flutter_livestream/providers/usuarios_provider.dart';
import 'package:provider/provider.dart';

class LivePage extends StatefulWidget {
  Usuario usuario;
  LivePage({Key? key, required this.usuario}) : super(key: key);

  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  leave() {
    context.read<LiveProvider>().leave(
          context.read<UsuariosProvider>().perfil,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final audiencia = context.watch<LiveProvider>().audiencia;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.usuario.avatar),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                widget.usuario.username,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 5.0,
                      color: Color.fromARGB(50, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 26,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Container(
              child: const Text(
                'AO VIVO',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              width: 65,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xffa50f87), Color(0xffdd0e49)],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
            child: Container(
              child: Text(
                audiencia.length.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              width: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.black.withOpacity(.5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
              onPressed: leave,
              icon: const Icon(Icons.close, size: 32),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[800],
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          Image.asset(
            'images/background.jpg',
            fit: BoxFit.fitHeight,
            height: 2000,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 110.0, right: 4),
            child: Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.mic_none,
                    size: 34,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.videocam_outlined,
                    size: 34,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.flip_camera_android_outlined,
                    size: 34,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
