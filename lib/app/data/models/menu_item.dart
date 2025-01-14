// Define classes to represent the data structure

import 'dart:convert';

class Category {
  final int id;
  final String name;
  final List<Dish> dishes;

  Category({
    required this.id,
    required this.name,
    required this.dishes,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    if (json['name'] == 'Salads and Soup') {
      print('Salads and Soup');
    }
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      dishes: (json['dishes'] as List).map((dishJson) {
        (json['name'] == 'Salads and Soup')
            ? dishJson['isVeg'] == true
            : dishJson['isVeg'] == false;
        return Dish.fromJson(dishJson);
      }).toList(),
    );
  }
}

class Dish {
  final int id;
  final String name;
  final String price;
  final String currency;
  final int calories;
  int? qty;
  final String description;
  final List<Addon> addons;
  final String imageUrl;
  final bool customizationsAvailable;
  final bool isVeg;

  Dish({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.calories,
    required this.description,
    required this.addons,
    required this.imageUrl,
    required this.customizationsAvailable,
    required this.isVeg,
    this.qty,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as String,
      currency: json['currency'] as String,
      calories: json['calories'] as int,
      description: json['description'] as String,
      addons: (json['addons'] as List)
          .map((addonJson) => Addon.fromJson(addonJson))
          .toList(),
      imageUrl: json['image_url'] ?? '',
      qty: json['qty'] ?? 0,
      customizationsAvailable: json['customizations_available'] ?? false,
      isVeg: false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'currency': currency,
      'calories': calories,
      'description': description,
      'addons': addons.map((addon) => addon.toJson()).toList(),
      'imageUrl': imageUrl,
      'customizationsAvailable': customizationsAvailable,
    };
  }
}

class Addon {
  final int id;
  final String name;
  final String price;

  Addon({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}

// Parsing the JSON data

List<Category> parseCategories(String jsonData) {
  final data = jsonDecode(jsonData) as List;
  return data.map((categoryJson) => Category.fromJson(categoryJson)).toList();
}
