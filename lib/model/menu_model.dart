class Menu {
  String? menuId;
  String namaMenu;
  double harga;
  bool status;

  Menu({
    this.menuId,
    required this.namaMenu,
    required this.harga,
    required this.status,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        menuId: json["menu_id"],
        namaMenu: json["nama_menu"],
        harga: json["harga"].toDouble(),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "menu_id": menuId,
        "nama_menu": namaMenu,
        "harga": harga,
        "status": status,
      };
}
