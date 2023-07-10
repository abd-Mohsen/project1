import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/components/products_row.dart';
import 'package:project1/controllers/home_controller.dart';
import 'package:project1/models/product_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        //todo:make banners with fixed height and width
        // todo: make banners sliver
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: PageView.builder(
              controller: hC.pageController,
              itemCount: hC.banners.length,
              itemBuilder: (context, i) => Container(
                color: cs.background,
                child: Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: hC.banners[i],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 15,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: GetBuilder<HomeController>(builder: (con) {
              if (hC.isLoadingProducts) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SpinKitWave(
                        color: cs.primary,
                        duration: const Duration(milliseconds: 1000),
                      ),
                      const SizedBox(height: 15),
                      Visibility(
                        visible: true, //todo:manage state
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("taking so long?   "),
                            ElevatedButton(
                              onPressed: () {
                                hC.refreshAllProducts();
                              },
                              child: Text("refresh"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else {
                if (!hC.isFetched) {
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
                        ),
                      ],
                    ),
                  );
                } else {
                  List<ProductModel> newestProductsList = hC.productsList;
                  newestProductsList.sort((a, b) => b.rating.rate.compareTo(a.rating.rate));
                  return ListView(
                    children: [
                      ProductsRow(
                        title: "for you".tr,
                        heroTag: "4u",
                        productsList: hC.productsList,
                      ),
                      ProductsRow(
                        title: "most liked".tr,
                        heroTag: "like",
                        productsList: newestProductsList,
                      ),
                      // ProductsRow(
                      //   title: "most liked".tr,
                      //   heroTag: "like",
                      //   productsList: mostLikedList,
                      // ),
                    ],
                  );
                }
              }
            }),
          ),
        ),
      ],
    );
  }
}
