import 'package:flutter/material.dart';
import 'package:ufc_kasir/ui/menu_page.dart';
import '../model/menu_model.dart';
import '../service/menu_service.dart'; // Pastikan Anda memiliki service untuk menu
import 'menu_detail.dart'; // Pastikan Anda mengimpor detail menu

class MenuUpdateForm extends StatefulWidget {
  final Menu menu;

  const MenuUpdateForm({Key? key, required this.menu}) : super(key: key);

  @override
  State<MenuUpdateForm> createState() => _MenuUpdateFormState();
}

class _MenuUpdateFormState extends State<MenuUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaMenuCtrl = TextEditingController();
  final _hargaCtrl = TextEditingController();
  bool _status = true;

  @override
  void initState() {
    super.initState();
    // Mengisi controller dengan data menu yang ada
    _namaMenuCtrl.text = widget.menu.namaMenu;
    _hargaCtrl.text = widget.menu.harga.toString();
    _status = widget.menu.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ubah Menu")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _fieldNamaMenu(),
              _fieldHarga(),
              _fieldStatus(),
              const SizedBox(height: 20),
              _tombolSimpan(),
            ],
          ),
        ),
      ),
    );
  }

  _fieldNamaMenu() {
    return TextField(
      controller: _namaMenuCtrl,
      decoration: const InputDecoration(labelText: "Nama Menu"),
    );
  }

  _fieldHarga() {
    return TextField(
      controller: _hargaCtrl,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: "Harga"),
    );
  }

  _fieldStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Status:"),
        Switch(
          value: _status,
          onChanged: (value) {
            setState(() {
              _status = value;
            });
          },
        ),
      ],
    );
  }

  _tombolSimpan() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          // Membuat objek Menu dengan data yang diperbarui
          Menu updatedMenu = Menu(
            menuId: widget.menu.menuId,
            namaMenu: _namaMenuCtrl.text,
            harga: double.parse(_hargaCtrl.text),
            status: _status,
          );

          // Mengupdate data menu
          await MenuService()
              .ubahMenu(updatedMenu, widget.menu.menuId.toString())
              .then((value) {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MenuPage()),
            );
          });
        }
      },
      child: const Text("Simpan Perubahan"),
    );
  }
}
