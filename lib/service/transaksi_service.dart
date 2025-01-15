import 'package:dio/dio.dart';
import '../helpers/api_client.dart';
import '../model/transaksi_model.dart';

class TransaksiService {
  Future<List<Transaksi>> listTransaksi() async {
    final Response response = await ApiClient().get('transaksi');
    final List data = response.data as List;
    return data.map((json) => Transaksi.fromJson(json)).toList();
  }

  Future<Transaksi> simpanTransaksi(Transaksi transaksi) async {
    var data = transaksi.toJson();
    final Response response = await ApiClient().post('transaksi', data);
    return Transaksi.fromJson(response.data);
  }

  Future<void> hapusTransaksi(String id) async {
    await ApiClient().delete('transaksi/$id');
  }
}
