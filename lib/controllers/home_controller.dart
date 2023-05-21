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

  // RxList<ProductModel> productsList = <ProductModel>[].obs; //todo
  late List<ProductModel> _productsList;
  bool _isLoadingProducts = true;
  bool get isLoadingProducts => _isLoadingProducts;
  bool _isFetched = true;
  bool get isFetched => _isFetched;
  List<ProductModel> get productsList => _productsList;
  toggleLoadingAndFetchedProducts(bool loading, bool fetched) {
    _isLoadingProducts = loading;
    _isFetched = fetched;
    update();
  }

  void getAllProductsList() async {
    try {
      _productsList = (await RemoteServices.fetchAllProducts().timeout(kTimeOutDuration))!;
      toggleLoadingAndFetchedProducts(true, true);
    } on TimeoutException {
      toggleLoadingAndFetchedProducts(false, false);
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
      toggleLoadingAndFetchedProducts(false, true);
    }
  }

  void refreshAllProducts() {
    toggleLoadingAndFetchedProducts(true, false);
    getAllProductsList();
  }

  //--------------------------------------------------------------------------------
  //for fetching current user from server

  Rx<UserModel> currentUser = UserModel(id: 0, email: "email", firstName: "first", lastName: "last", avatar: "").obs;
  RxBool isLoadingUser = true.obs;

  void getCurrentUser() async {
    try {
      currentUser.value = (await RemoteServices.fetchCurrentUser(_getStorage.read("token")))!;
    } catch (e) {
      _getStorage.remove("token");
      Get.offAll(() => LoginPage()); //todo:
      Get.defaultDialog(
        title: "error",
        middleText: "please login again",
      );
    } finally {
      isLoadingUser.value = false;
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

  final Map<int, ProductModel> _searchHistoryMap = {};
  Map<int, ProductModel> get searchHistoryMap => _searchHistoryMap;
  //used a map to insure that products with same id wont duplicate after refreshing the list

  void addToSearchHistory(ProductModel product) {
    _searchHistoryMap[product.id] = product;
    update();
    saveSearchHistoryInLocalStorage();
  }

  void removeFromHistory(ProductModel product) {
    _searchHistoryMap.remove(product.id);
    update();
    saveSearchHistoryInLocalStorage();
  }

  void loadSearchHistoryFromLocalStorage() {
    if (_getStorage.read("search history") != null) {
      List<ProductModel> mapAsList = productModelFromJson(_getStorage.read("search history"));
      for (ProductModel productModel in mapAsList) {
        _searchHistoryMap[productModel.id] = productModel;
      }
    }
  }

  void saveSearchHistoryInLocalStorage() {
    List<ProductModel> mapAsList = _searchHistoryMap.entries.map((entry) => entry.value).toList();
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

  RxBool isLoadingConfirmPassword = false.obs;

  GlobalKey<FormState> settingsFormKey = GlobalKey<FormState>();

  bool buttonPressed = false;

  //todo:
  void confirmPassword(String password) async {
    buttonPressed = true;
    bool flag = settingsFormKey.currentState!.validate();
    if (flag) {
      isLoadingConfirmPassword.value = true;
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
        isLoadingConfirmPassword.value = false;
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
