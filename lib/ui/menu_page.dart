import 'package:flutter/material.dart';
import '../service/menu_service.dart';
import '../model/menu_model.dart';
import 'menu_form.dart';
import 'menu_item.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Stream<List<Menu>> getMenuList() async* {
    List<Menu> data = await MenuService().listMenu();
    yield data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuForm()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: getMenuList(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return const Center(child: Text("Tidak ada data"));
          }

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return MenuItem(menu: snapshot.data[index]);
            },
          );
        },
      ),
    );
  }
}
