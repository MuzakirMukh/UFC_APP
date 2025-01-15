import 'package:flutter/material.dart';
import '../model/menu_model.dart';
import '../model/transaksi_model.dart';
import '../service/menu_service.dart';
import '../service/transaksi_service.dart';

class KasirPage extends StatefulWidget {
  const KasirPage({Key? key}) : super(key: key);

  @override
  State<KasirPage> createState() => _KasirPageState();
}

class _KasirPageState extends State<KasirPage> {
  List<Menu> _menuList = [];
  Map<String, int> _selectedMenu = {}; // Menu ID dan jumlah
  double _total = 0.0;
  final _namaPemesanCtrl = TextEditingController();
  final _nomorMejaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMenu();
  }

  Future<void> _fetchMenu() async {
    try {
      List<Menu> menuList = await MenuService().listMenu();
      setState(() {
        // Filter menu yang statusnya true
        _menuList = menuList.where((menu) => menu.status).toList();
      });
    } catch (e) {
      // Tampilkan pesan kesalahan jika gagal memuat menu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat menu: $e")),
      );
    }
  }

  void _updateTotal() {
    _total = 0.0;
    _selectedMenu.forEach((menuId, jumlah) {
      final menu = _menuList.firstWhere((m) => m.menuId == menuId);
      _total += menu.harga * jumlah;
    });
  }

  void _addToCart(String menuId) {
    setState(() {
      _selectedMenu[menuId] = (_selectedMenu[menuId] ?? 0) + 1;
      _updateTotal();
    });
  }

  void _removeFromCart(String menuId) {
    setState(() {
      if (_selectedMenu.containsKey(menuId)) {
        _selectedMenu[menuId] = (_selectedMenu[menuId]! - 1);
        if (_selectedMenu[menuId] == 0) {
          _selectedMenu.remove(menuId);
        }
        _updateTotal();
      }
    });
  }

  void _checkout() async {
    if (_namaPemesanCtrl.text.isEmpty || _nomorMejaCtrl.text.isEmpty) {
      // Tampilkan pesan kesalahan jika nama pemesan atau nomor meja kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Nama pemesan dan nomor meja harus diisi")),
      );
      return;
    }

    for (var entry in _selectedMenu.entries) {
      final menu = _menuList.firstWhere((m) => m.menuId == entry.key);
      final transaksi = Transaksi(
        menuId: menu.menuId!,
        namaMenu: menu.namaMenu, // Tambahkan nama menu ke transaksi
        jumlah: entry.value,
        total: menu.harga * entry.value,
        namaPemesan: _namaPemesanCtrl.text,
        nomorMeja: _nomorMejaCtrl.text,
        createdAt: DateTime.now(),
      );
      try {
        await TransaksiService().simpanTransaksi(transaksi);
      } catch (e) {
        // Tampilkan pesan kesalahan jika gagal menyimpan transaksi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan transaksi: $e")),
        );
        return;
      }
    }

    // Reset setelah checkout
    setState(() {
      _selectedMenu.clear();
      _total = 0.0;
      _namaPemesanCtrl.clear();
      _nomorMejaCtrl.clear();
    });

    // Tampilkan pesan sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Transaksi berhasil disimpan!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Halaman Kasir")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _namaPemesanCtrl,
              decoration: const InputDecoration(labelText: "Nama Pemesan"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nomorMejaCtrl,
              decoration: const InputDecoration(labelText: "Nomor Meja"),
              keyboardType: TextInputType.number,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _menuList.length,
              itemBuilder: (context, index) {
                final menu = _menuList[index];
                return ListTile(
                  title: Text(menu.namaMenu),
                  subtitle: Text("Harga: Rp${menu.harga.toStringAsFixed(2)}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _removeFromCart(menu.menuId!),
                      ),
                      Text(_selectedMenu[menu.menuId]?.toString() ?? '0'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _addToCart(menu.menuId!),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Total: Rp${_total.toStringAsFixed(2)}"),
          ),
          ElevatedButton(
            onPressed: _checkout,
            child: const Text("Selesai"),
          ),
        ],
      ),
    );
  }
}
