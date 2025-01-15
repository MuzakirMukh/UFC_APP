import 'package:flutter/material.dart';
import '../model/menu_model.dart';

class MenuForm extends StatefulWidget {
  const MenuForm({Key? key}) : super(key: key);

  @override
  State<MenuForm> createState() => _MenuFormState();
}

class _MenuFormState extends State<MenuForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaMenuCtrl = TextEditingController();
  final _hargaCtrl = TextEditingController();
  bool _status = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Menu")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller: _namaMenuCtrl,
                decoration: const InputDecoration(labelText: "Nama Menu"),
              ),
              TextField(
                controller: _hargaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Harga"),
              ),
              Row(
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
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Menu menu = Menu(
                      namaMenu: _namaMenuCtrl.text,
                      harga: double.parse(_hargaCtrl.text),
                      status: _status,
                    );
                    // Simpan ke backend
                    Navigator.pop(context, menu);
                  }
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
