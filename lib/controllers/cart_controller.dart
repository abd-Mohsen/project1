import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/product_model.dart';

//todo: every product model should have a maximum quantity allowed in cart , or at least every category
class CartController extends GetxController {
  final _getStorage = GetStorage();

  final Map<int, ProductModel> _cart = {};
  Map<int, ProductModel> get cart => _cart;

  final Map<int, int> _quantity = {};
  Map<int, int> get quantity => _quantity;

  //i used a map instead of a list to not duplicate products after refreshing the fetched list
  //if the user refreshes the list the same products will be fetched but will be stored in different part in memory
  //so the app will see them as a different products
  //by using a map and link every product to its unique id we can avoid this problem
  //and i used a second map to store the amount of each product in the cart in the same way
  //the cart and quantity are stored in the device's local storage
  //on every modification on the cart or the quantity we store the values in local storage
  //in the keys "cart" and "cart quantity" to restore them later by using the method loadCartFromLocalStorage();
  //the method loadCartFromLocalStorage(); will be called on every CartController() initialization

  @override
  void onInit() {
    super.onInit();
    loadCartFromLocalStorage();
  }

  void addToCart(ProductModel product) {
    _cart[product.id] = product;
    _quantity[product.id] = 1;
    update();
    saveCartInLocalStorage();
  }

  void removeFromCart(ProductModel product) {
    _cart.remove(product.id);
    _quantity.remove(product.id);
    update();
    saveCartInLocalStorage();
  }

  void clearCart() {
    _cart.clear();
    _quantity.clear();
    update();
    saveCartInLocalStorage();
  }

  void increaseProductCount(ProductModel product) {
    if (_quantity[product.id]! < 3) {
      _quantity[product.id] = (_quantity[product.id]! + 1);
      update();
      saveCartInLocalStorage();
    }
  }

  void decreaseProductCount(ProductModel product) {
    if (_quantity[product.id]! > 1) {
      _quantity[product.id] = (_quantity[product.id]! - 1);
      update();
      saveCartInLocalStorage();
    }
  }

  void saveCartInLocalStorage() {
    List<ProductModel> cartAsList = _cart.entries.map((e) => e.value).toList();
    List<int> countAsList = _quantity.entries.map((e) => e.value).toList();
    _getStorage.write("cart", productModelToJson(cartAsList));
    _getStorage.write("cart quantity", jsonEncode(countAsList));
  }

  void loadCartFromLocalStorage() {
    if (_getStorage.read("cart") != null && _getStorage.read("cart quantity") != null) {
      List<ProductModel> cartAsList = productModelFromJson(_getStorage.read("cart"));
      List countAsList = jsonDecode(_getStorage.read("cart quantity"));
      for (int i = 0; i < cartAsList.length; i++) {
        _cart[cartAsList[i].id] = cartAsList[i];
        _quantity[cartAsList[i].id] = countAsList[i];
      }
    }
  }

  Future makeOrder() async {
    //send each id and its quantity
    print(_quantity);
  }

  double get totalPrice {
    double sum = 0;
    for (ProductModel product in _cart.values) {
      sum += product.price * _quantity[product.id]!;
    }
    return sum;
  }

  int get totalProductsAmount {
    int sum = 0;
    for (ProductModel product in _cart.values) {
      sum += 1 * _quantity[product.id]!;
    }
    return sum;
  }
}
