import 'dart:convert';

import 'package:flutter_firebase/app/data/models/menu_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  static setMenuItems(List<Dish> menuItems) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
        menuItems.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('menuItems', jsonList);
  }

  static Future<List<Dish>> getMenuItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('menuItems');
    if (jsonList != null) {
      return jsonList.map((item) => Dish.fromJson(jsonDecode(item))).toList();
    }
    return [];
  }

  static getStringFromSharedPrefrences({
    required String key,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    return value;
  }

  static getListFromSharedPrefrences({
    required String key,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? value = prefs.getStringList(key);
    return value;
  }

  static removeFromSharedPrefrences({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, '');
  }

  static Future<void> clearPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
