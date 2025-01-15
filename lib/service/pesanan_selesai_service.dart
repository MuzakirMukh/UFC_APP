import 'package:dio/dio.dart';
import '../helpers/api_client.dart';
import '../model/pesanan_selesai_model.dart';

class PesananSelesaiService {
  // Metode untuk menyimpan pesanan selesai
  Future<PesananSelesai> simpanPesananSelesai(
      PesananSelesai pesananSelesai) async {
    var data = pesananSelesai.toJson();
    final Response response = await ApiClient().post(
      'pesanan_selesai',
      data,
    );
    return PesananSelesai.fromJson(response.data);
  }

  Future<List<PesananSelesai>> listPesananSelesai() async {
    final Response response = await ApiClient().get('pesanan_selesai');
    final List data = response.data as List;
    return data.map((json) => PesananSelesai.fromJson(json)).toList();
  }

  Future<void> hapusPesananSelesai(String id) async {
    await ApiClient().delete('pesanan_selesai/$id');
  }
}
