import 'package:flutter/material.dart';
import '../model/transaksi_model.dart';
import '../model/pesanan_selesai_model.dart';
import '../service/transaksi_service.dart';
import '../service/pesanan_selesai_service.dart';
import '../service/menu_service.dart';

class AntrianPesananPage extends StatelessWidget {
  const AntrianPesananPage({Key? key}) : super(key: key);

  // Fungsi untuk mengambil nama menu berdasarkan menuId
  Future<Map<String, String>> _fetchMenuNames() async {
    final menuList = await MenuService().listMenu();

    // Filter hanya menu yang memiliki menuId dan namaMenu yang valid
    final validMenuList =
        menuList.where((menu) => menu.menuId != null && menu.namaMenu != null);

    // Konversi menjadi Map
    return {for (var menu in validMenuList) menu.menuId!: menu.namaMenu!};
  }

  // Fungsi untuk memindahkan transaksi ke pesanan selesai
  Future<void> _pesananSelesai(
    String transaksiId,
    List<Transaksi> transaksiGroup,
  ) async {
    for (var transaksi in transaksiGroup) {
      final pesananSelesai = PesananSelesai(
        transaksiId: transaksi.transaksiId,
        menuId: transaksi.menuId,
        jumlah: transaksi.jumlah,
        total: transaksi.total,
        namaPemesan: transaksi.namaPemesan,
        nomorMeja: transaksi.nomorMeja,
        createdAt: DateTime.now(),
        namaMenu: '',
      );
      await PesananSelesaiService().simpanPesananSelesai(pesananSelesai);
    }

    // Hapus transaksi setelah dipindahkan
    for (var transaksi in transaksiGroup) {
      await TransaksiService().hapusTransaksi(transaksi.transaksiId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Antrian Pesanan")),
      body: FutureBuilder<Map<String, String>>(
        future: _fetchMenuNames(),
        builder: (context, menuSnapshot) {
          if (menuSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (menuSnapshot.hasError) {
            return Center(child: Text("Error: ${menuSnapshot.error}"));
          }
          if (!menuSnapshot.hasData) {
            return const Center(child: Text("Tidak ada data menu"));
          }

          final menuMap = menuSnapshot.data!;
          return FutureBuilder<List<Transaksi>>(
            future: TransaksiService().listTransaksi(),
            builder: (context, transaksiSnapshot) {
              if (transaksiSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (transaksiSnapshot.hasError) {
                return Center(child: Text("Error: ${transaksiSnapshot.error}"));
              }
              if (!transaksiSnapshot.hasData ||
                  transaksiSnapshot.data!.isEmpty) {
                return const Center(child: Text("Tidak ada pesanan"));
              }

              final transaksiList = transaksiSnapshot.data!;
              // Kelompokkan transaksi berdasarkan transaksiId
              final groupedTransaksi = <String, List<Transaksi>>{};
              for (var transaksi in transaksiList) {
                groupedTransaksi
                    .putIfAbsent(transaksi.transaksiId!, () => [])
                    .add(transaksi);
              }

              return ListView(
                children: groupedTransaksi.entries.map((entry) {
                  final transaksiId = entry.key;
                  final transaksiGroup = entry.value;

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Nama Pemesan dan Nomor Meja
                          Text(
                            "Nama Pemesan: ${transaksiGroup.first.namaPemesan}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Nomor Meja: ${transaksiGroup.first.nomorMeja}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16.0),
                          // Tabel Pesanan
                          Table(
                            border: TableBorder.all(color: Colors.grey),
                            columnWidths: const {
                              0: FlexColumnWidth(2), // Lebar kolom pertama
                              1: FlexColumnWidth(1), // Lebar kolom kedua
                            },
                            children: [
                              // Header tabel
                              const TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Nama Menu",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Jumlah",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              // Data tabel
                              ...transaksiGroup.map((transaksi) {
                                final namaMenu = menuMap[transaksi.menuId] ??
                                    "Menu Tidak Ditemukan";
                                return TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(namaMenu),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(transaksi.jumlah.toString()),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          // Tombol Pesanan Selesai
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () async {
                                await _pesananSelesai(
                                    transaksiId, transaksiGroup);
                                (context as Element)
                                    .reassemble(); // Refresh halaman
                              },
                              child: const Text("Pesanan Selesai"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
