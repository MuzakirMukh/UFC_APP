import 'package:flutter/material.dart';
import '../model/menu_model.dart';

class MenuDetail extends StatelessWidget {
  final Menu menu;

  const MenuDetail({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Menu")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama Menu: ${menu.namaMenu}", style: TextStyle(fontSize: 18)),
            Text("Harga: ${menu.harga}", style: TextStyle(fontSize: 18)),
            Text("Status: ${menu.status ? 'Tersedia' : 'Habis'}",
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
