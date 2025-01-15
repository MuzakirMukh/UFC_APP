class Transaksi {
  String? transaksiId;
  String menuId;
  String namaMenu; // Tambahkan namaMenu
  int jumlah;
  double total;
  String namaPemesan;
  String nomorMeja;
  DateTime createdAt;

  Transaksi({
    this.transaksiId,
    required this.menuId,
    required this.namaMenu, // Tambahkan ke constructor
    required this.jumlah,
    required this.total,
    required this.namaPemesan,
    required this.nomorMeja,
    required this.createdAt,
  });

  // Perbarui factory fromJson untuk mendukung namaMenu
  factory Transaksi.fromJson(Map<String, dynamic> json) => Transaksi(
        transaksiId: json["transaksi_id"],
        menuId: json["menu_id"],
        namaMenu: json["nama_menu"], // Parsing namaMenu
        jumlah: json["jumlah"],
        total: json["total"].toDouble(),
        namaPemesan: json["nama_pemesan"],
        nomorMeja: json["nomor_meja"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  // Perbarui toJson untuk menyertakan namaMenu
  Map<String, dynamic> toJson() => {
        "transaksi_id": transaksiId,
        "menu_id": menuId,
        "nama_menu": namaMenu, // Tambahkan namaMenu
        "jumlah": jumlah,
        "total": total,
        "nama_pemesan": namaPemesan,
        "nomor_meja": nomorMeja,
        "created_at": createdAt.toIso8601String(),
      };
}
