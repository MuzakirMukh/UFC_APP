import 'package:flutter/material.dart';
import '../model/pesanan_selesai_model.dart';
import '../service/pesanan_selesai_service.dart';

class PesananSelesaiPage extends StatelessWidget {
  const PesananSelesaiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pesanan Sudah Selesai")),
      body: FutureBuilder<List<PesananSelesai>>(
        future: PesananSelesaiService().listPesananSelesai(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada pesanan selesai"));
          }

          final pesananList = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Nama Pemesan")),
                DataColumn(label: Text("Nomor Meja")),
                DataColumn(label: Text("Nama Menu")),
                DataColumn(label: Text("Jumlah")),
                DataColumn(label: Text("Total")),
              ],
              rows: pesananList.map((pesanan) {
                return DataRow(cells: [
                  DataCell(Text(pesanan.namaPemesan)),
                  DataCell(Text(pesanan.nomorMeja)),
                  DataCell(Text(pesanan.namaMenu)), // Nama menu ditampilkan
                  DataCell(Text(pesanan.jumlah.toString())),
                  DataCell(Text("Rp${pesanan.total.toStringAsFixed(2)}")),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
