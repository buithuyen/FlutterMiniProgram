import 'package:flutter/material.dart';
import 'package:mini_app/src/presentation/home_page/widgets/renderer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: Builder(builder: (BuildContext context) {
          return const Renderer();
        }));
  }
}
