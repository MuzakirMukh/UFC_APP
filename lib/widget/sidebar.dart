import 'package:flutter/material.dart';
import '../ui/beranda.dart';
import '../ui/login.dart';
import '../ui/pesanan_selesai_page.dart';
import '../ui/antrian_pesanan_page.dart';
import '../ui/menu_page.dart';
import '../ui/kasir_page.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Admin"),
            accountEmail: Text("admin@admin.com"),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Beranda"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Beranda()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text("Kasir"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KasirPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text("Data Pesanan"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AntrianPesananPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text("Daftar Menu"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_box),
            title: const Text("Pesanan Selesai"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PesananSelesaiPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text("Keluar"),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
