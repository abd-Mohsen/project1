import 'package:get/get.dart';

class OrdersController extends GetxController {
  @override
  void onInit() {
    getOrders();
    super.onInit();
  }

  Future getOrders() async {
    //fetch orders from api
  }
}
