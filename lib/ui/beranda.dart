import 'package:flutter/material.dart';
import '../widget/sidebar.dart';
import 'kasir_page.dart';
import 'antrian_pesanan_page.dart';
import 'menu_page.dart';
import 'pesanan_selesai_page.dart';

class Beranda extends StatelessWidget {
  const Beranda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(title: const Text("Beranda")),
      body: GridView.count(
        crossAxisCount: 2, // Menentukan jumlah kolom (4 kolom)
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: [
          _buildCard('Kasir', Icons.account_balance_wallet, context,
              const KasirPage()),
          _buildCard('Data Pesanan', Icons.list_alt, context,
              const AntrianPesananPage()),
          _buildCard('Daftar Menu', Icons.menu_book, context, const MenuPage()),
          _buildCard('Pesanan Selesai', Icons.check_box, context,
              const PesananSelesaiPage()),
        ],
      ),
    );
  }

  // Widget untuk membuat card dengan icon di tengahnya
  Widget _buildCard(
      String title, IconData icon, BuildContext context, Widget page) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blueAccent.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
