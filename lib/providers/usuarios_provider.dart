import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_livestream/models/usuario.dart';

class UsuariosProvider extends ChangeNotifier {
  final List<Usuario> _usuarios = [];
  late final String _username;

  UnmodifiableListView<Usuario> get usuarios => UnmodifiableListView(_usuarios);
  Usuario get usuarioLogado => usuarios.firstWhere((u) => u.username == _username);

  login(Usuario usuario) {
    _username = usuario.username;
  }

  startLive() {
    _usuarios.firstWhere((u) => u.username == _username).aovivo = true;
    notifyListeners();
  }

  endLive() {
    _usuarios.firstWhere((u) => u.username == _username).aovivo = false;
    notifyListeners();
  }

  story(Usuario usuario) {
    _usuarios.add(usuario);
    addTestLive(usuario);
    notifyListeners();
  }

  removeStory(Usuario usuario) {
    _usuarios.remove(usuario);
    notifyListeners();
  }

  addTestLive(Usuario usuario) {
    if (usuario.username != 'diego') {
      _usuarios.add(
        Usuario(
          username: 'diego',
          avatar: "https://robohash.org/diego.png?set=set3",
        )..aovivo = true,
      );
    }
  }

  addTestUsers() {
    _usuarios.addAll([
      Usuario(
        username: 'joao',
        avatar: "https://robohash.org/joao.png?set=set3",
      ),
      Usuario(
        username: 'priscila',
        avatar: "https://robohash.org/priscila.png?set=set3",
      ),
      Usuario(
        username: 'marcos.paulo',
        avatar: "https://robohash.org/marcos.paulo.png?set=set3",
      ),
      Usuario(
        username: 'maria',
        avatar: "https://robohash.org/maria.png?set=set3",
      ),
    ]);
  }
}
