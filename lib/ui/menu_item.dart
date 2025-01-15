import 'package:flutter/material.dart';
import '../model/menu_model.dart';
import 'menu_detail.dart';
import 'menu_update_form.dart';

class MenuItem extends StatelessWidget {
  final Menu menu;

  const MenuItem({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuDetail(menu: menu)),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(menu.namaMenu),
          subtitle: Text(
              "Harga: ${menu.harga} - Status: ${menu.status ? 'Tersedia' : 'Habis'}"),
          trailing: IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () async {
              final updatedMenu = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MenuUpdateForm(menu: menu)),
              );

              if (updatedMenu != null) {
                // Perbarui UI dengan data terbaru
              }
            },
          ),
        ),
      ),
    );
  }
}
