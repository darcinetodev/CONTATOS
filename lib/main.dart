import 'package:flutter/material.dart';
import 'package:contatos/view/PeoplesView.dart';

void main() => runApp(MensageiroApp());

class MensageiroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mensageiro Online',
      home: PeoplesView(),
    );
  }
}
