import 'package:dio/dio.dart';
import '../helpers/api_client.dart';
import '../model/menu_model.dart';

class MenuService {
  Future<List<Menu>> listMenu() async {
    final Response response = await ApiClient().get('menu');
    final List data = response.data as List;
    List<Menu> result = data.map((json) => Menu.fromJson(json)).toList();
    return result;
  }

  Future<Menu> simpanMenu(Menu menu) async {
    var data = menu.toJson();
    final Response response = await ApiClient().post('menu', data);
    return Menu.fromJson(response.data);
  }

  Future<Menu> ubahMenu(Menu menu, String id) async {
    var data = menu.toJson();
    final Response response = await ApiClient().put('menu/$id', data);
    return Menu.fromJson(response.data);
  }

  Future<Menu> hapusMenu(String id) async {
    final Response response = await ApiClient().delete('menu/$id');
    return Menu.fromJson(response.data);
  }
}
