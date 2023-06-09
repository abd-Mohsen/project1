import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project1/constants.dart';
import 'package:project1/models/product_model.dart';
import 'package:project1/models/user_model.dart';
import 'package:pusher_client/pusher_client.dart';
import '../services/remote_services.dart';
import '../views/login_page.dart';

class HomeController extends GetxController {
  final _getStorage = GetStorage(); //local storage

  @override
  void onInit() {
    super.onInit();
    initPusher();
    getAllProductsList();
    loadSearchHistoryFromLocalStorage();
    startAutoScrollingBanners();
    if (_getStorage.hasData("token")) getCurrentUser();
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel(); //stop auto scrolling
    pusher.disconnect();
  }

  //--------------------------------------------------------------------------------
  //for fetching products from server

  late List<ProductModel> _productsList;
  List<ProductModel> get productsList => _productsList;
  bool _isLoadingProducts = true;
  bool get isLoadingProducts => _isLoadingProducts;
  bool _isFetched = false;
  bool get isFetched => _isFetched;

  void setLoadingProduct(bool value) {
    _isLoadingProducts = value;
    update();
  }

  void setFetched(bool value) {
    _isFetched = value;
    update();
  }

  void getAllProductsList() async {
    try {
      _productsList = (await RemoteServices.fetchAllProducts().timeout(kTimeOutDuration))!;
      setFetched(true);
    } on TimeoutException {
      setLoadingProduct(false);
    } catch (e) {
      //todo: show different message if it was a server error
      // Get.defaultDialog(
      //     title: "error",
      //     middleText: "network or server error: $e",
      //     confirm: Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: GestureDetector(
      //         onTap: () {
      //           getAllProductsList();
      //           Get.back();
      //         },
      //         child: Text("refresh".tr),
      //       ),
      //     ));
    } finally {
      setLoadingProduct(false);
    }
  }

  void refreshAllProducts() {
    setFetched(false);
    setLoadingProduct(true);
    getAllProductsList();
  }

  //--------------------------------------------------------------------------------
  //for fetching current user from server

  late UserModel _currentUser;
  UserModel get currentUser => _currentUser;
  bool _isLoadingUser = true;
  bool get isLoadingUser => _isLoadingUser;

  void getCurrentUser() async {
    try {
      _currentUser = (await RemoteServices.fetchCurrentUser(_getStorage.read("token")))!;
    } catch (e) {
      _getStorage.remove("token");
      Get.offAll(() => LoginPage()); //todo:
      Get.defaultDialog(
        title: "error",
        middleText: "please login again",
      );
    } finally {
      _isLoadingUser = false;
    }
  }

  void logOut() async {
    if (await RemoteServices.signOut(_getStorage.read("token"))) {
      _getStorage.remove("token");
      Get.offAll(() => LoginPage());
    }
  }

  //--------------------------------------------------------------------------------
  //for banners auto-scroll

  final List<Image> banners = [
    Image.asset("assets/images/banner-05.png"),
    Image.asset("assets/images/banner-06.png"),
    Image.asset("assets/images/banner-01.jpg"),
    Image.asset("assets/images/banner-02.jpg"),
    Image.asset("assets/images/banner-03.jpg"),
  ];
  //used banners from assets since backend isn't ready yet

  int _currentPage = 0;
  late Timer _timer;
  final PageController _pageController = PageController(initialPage: 0);
  PageController get pageController => _pageController;

  void startAutoScrollingBanners() {
    _timer = Timer.periodic(
      const Duration(seconds: 4),
      (timer) {
        if (_currentPage < banners.length) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      },
    );
  }

  //--------------------------------------------------------------------------------
  //for search history

  //todo: show "product is no longer available" if user clicked on a deleted product in search history
  //todo: and remove it from history
  final Map<int, ProductModel> _searchHistory = {};
  Map<int, ProductModel> get searchHistory => _searchHistory;
  //used a map to insure that products with same id wont duplicate after refreshing the list

  void addToSearchHistory(ProductModel product) {
    _searchHistory[product.id] = product;
    update();
    saveSearchHistoryInLocalStorage();
  }

  void removeFromSearchHistory(ProductModel product) {
    _searchHistory.remove(product.id);
    update();
    saveSearchHistoryInLocalStorage();
  }

  void loadSearchHistoryFromLocalStorage() {
    if (_getStorage.read("search history") != null) {
      List<ProductModel> mapAsList = productModelFromJson(_getStorage.read("search history"));
      for (ProductModel productModel in mapAsList) {
        _searchHistory[productModel.id] = productModel;
      }
    }
  }

  void saveSearchHistoryInLocalStorage() {
    List<ProductModel> mapAsList = _searchHistory.entries.map((entry) => entry.value).toList();
    _getStorage.write("search history", productModelToJson(mapAsList));
  }

  //--------------------------------------------------------------------------------
  //for bottom bar navigation

  int _selectedIndex = 1; //initial scaffold body index (home tab)
  int get selectedIndex => _selectedIndex; //getter

  void changeTab(int index) {
    _selectedIndex = index;
    update(); //this method from GetXController class rebuilds all the widgets wrapped in getBuilder<ThisController>
  }

  //---------------------------------------------------------------------------------
  //for edit profile

  bool _isLoadingConfirmPassword = false;
  bool get isLoadingConfirmPassword => _isLoadingConfirmPassword;

  GlobalKey<FormState> settingsFormKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;
  void togglePasswordVisibility(bool value) {
    _passwordVisible = value;
    update();
  }

  //todo:
  void confirmPassword(String password) async {
    buttonPressed = true;
    if (settingsFormKey.currentState!.validate()) {
      _isLoadingConfirmPassword = true;
      Timer(const Duration(seconds: 4), () {
        if (password == "12345") {
          //go to page
          print("ok");
        } else {
          Get.showSnackbar(GetSnackBar(
            messageText: Text(
              "wrong password".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.grey.shade800,
            duration: const Duration(milliseconds: 800),
            borderRadius: 30,
            maxWidth: 150,
            margin: const EdgeInsets.only(bottom: 50),
          ));
        }
        _isLoadingConfirmPassword = false;
      });
    }
  }

  //---------------------------------------------------------------------------------
  //for pusher

  PusherClient pusher = PusherClient("6d8a30fe15f00eb58c79", PusherOptions(cluster: "eu"));

  Future initPusher() async {
    pusher.connect();
    pusher.onConnectionError((error) {
      print("error: ${error!.message}");
    });
    Channel channel = pusher.subscribe("abd_channel");

    channel.bind("refresh_products", (event) {
      refreshAllProducts();
    });

    channel.bind("push_notification", (event) {
      Get.defaultDialog(
          title: "notification",
          middleText: " used a dialog for test only, we will make a proper notification popup later");
    });
    // pusher.onConnectionStateChange((state) {
    //   print("previousState: ${state!.previousState}, currentState: ${state.currentState}");
    // });
  }
}
