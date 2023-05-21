import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../components/products_row.dart';
import '../../controllers/home_controller.dart';
import '../../models/product_model.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  List<ProductModel> filteredProductsByCategory(List<ProductModel> list, String selectedCategory) {
    List<ProductModel> filteredList = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i].category == selectedCategory) {
        filteredList.add(list[i]);
      }
    }
    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    HomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Obx(() {
              if (hC.isLoadingProducts.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitFadingCube(
                        color: cs.primary,
                        duration: const Duration(milliseconds: 1000),
                      ),
                    ],
                  ),
                );
              } else {
                if (!hC.isFetched.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.network_wifi_1_bar, color: Colors.red, size: 60),
                        ElevatedButton(
                          onPressed: () {
                            hC.refreshAllProducts();
                          },
                          child: Text("refresh"),
                        )
                      ],
                    ),
                  );
                }
                List<String> categoriesList = hC.productsList.map((product) => product.category).toSet().toList();
                return ListView.builder(
                  itemCount: categoriesList.length,
                  itemBuilder: (context, i) => ProductsRow(
                    title: categoriesList[i],
                    heroTag: categoriesList[i],
                    productsList: filteredProductsByCategory(hC.productsList, categoriesList[i]),
                  ),
                );
              }
            }),
          ),
        ),
      ],
    );
  }
}
