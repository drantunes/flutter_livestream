import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_livestream/models/usuario.dart';
import 'package:flutter_livestream/providers/live_provider.dart';
import 'package:flutter_livestream/providers/usuarios_provider.dart';
import 'package:provider/provider.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:permission_handler/permission_handler.dart';

class LivePage extends StatefulWidget {
  final Usuario usuario;
  const LivePage({Key? key, required this.usuario}) : super(key: key);

  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  final appId = dotenv.env['AGORA_APPID'].toString();
  final token = dotenv.env['AGORA_TOKEN'].toString();
  int remoteUid = 0;
  bool entrou = false;
  late RtcEngine engine;
  ClientRole role = ClientRole.Broadcaster;

  @override
  void initState() {
    super.initState();
    setLiveMode();
  }

  @override
  void dispose() {
    engine.destroy();
    super.dispose();
  }

  setLiveMode() async {
    String hostLive = widget.usuario.username;
    String usuarioLogado = context.read<UsuariosProvider>().usuarioLogado.username;
    if (hostLive == usuarioLogado) {
      role = ClientRole.Broadcaster;
    } else {
      role = ClientRole.Audience;
    }
    await startBroadcast();
  }

  Future<void> startBroadcast() async {
    await [Permission.camera, Permission.microphone].request();

    engine = await RtcEngine.createWithContext(RtcEngineContext(appId));

    engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, _) => joinChannel(),
        userJoined: (int uid, _) => join(uid),
        userOffline: (int uid, UserOfflineReason reason) => leave(uid),
      ),
    );

    await engine.enableVideo();
    await engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await engine.setClientRole(role);
    await engine.joinChannel(token, widget.usuario.username, null, 0);
  }

  joinChannel() {
    setState(() => entrou = true);
  }

  join(int uid) {
    setState(() => remoteUid = uid);
    context.read<LiveProvider>().join(
          context.read<UsuariosProvider>().usuarioLogado,
        );
  }

  close() async {
    if (remoteUid != 0) {
      await engine.leaveChannel();
    }
    leave(remoteUid);
  }

  leave(int uid) {
    setState(() => remoteUid = 0);
    final usuarioLogado = context.read<UsuariosProvider>().usuarioLogado;
    context.read<LiveProvider>().leave(usuarioLogado);
    Navigator.pop(context);
  }

  Widget _renderLocalPreview() {
    if (widget.usuario.aovivo && entrou) {
      return rtc_local_view.SurfaceView();
    } else {
      return const Text(
        'Please join channel first',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _renderRemoteVideo() {
    if (remoteUid != 0) {
      return rtc_remote_view.SurfaceView(
        uid: remoteUid,
        mirrorMode: VideoMirrorMode.Enabled,
        renderMode: VideoRenderMode.Fit,
      );
    } else {
      return const Text(
        'Please wait remote user join',
      );
    }
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 5.0,
                      color: Color.fromARGB(150, 0, 0, 0),
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
              onPressed: close,
              icon: const Icon(Icons.close, size: 32),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[800],
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          if (role == ClientRole.Broadcaster)
            _renderLocalPreview()
          else if (remoteUid != 0 && role == ClientRole.Audience)
            _renderRemoteVideo(),
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
