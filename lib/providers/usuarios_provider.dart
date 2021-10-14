import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_livestream/models/usuario.dart';

class UsuariosProvider extends ChangeNotifier {
  final List<Usuario> _usuarios = [];
  late final String _username;

  UnmodifiableListView<Usuario> get usuarios => UnmodifiableListView(_usuarios);
  Usuario get perfil => usuarios.firstWhere((u) => u.username == _username);

  login(Usuario usuario) {
    _username = usuario.username;
  }

  startLive() {
    _usuarios.firstWhere((u) => u.username == _username).aovivo = true;
    notifyListeners();
  }

  join(Usuario usuario) {
    _usuarios.add(usuario);
    addTestUsers();
    notifyListeners();
  }

  leave(Usuario usuario) {
    _usuarios.remove(usuario);
    notifyListeners();
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
