import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:project1/controllers/cart_controller.dart';
import '../constants.dart';
import '../models/product_model.dart';

class ProductView extends StatelessWidget {
  final ProductModel product;
  final String heroTag;

  const ProductView({
    super.key,
    required this.product,
    required this.heroTag,
  });

  //todo: make comments
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: GetBuilder<CartController>(
            init: CartController(),
            builder: (con) {
              return SpeedDial(
                //controller: AnimationController(vsync: t), //todo:
                labelsBackgroundColor: cs.onSurface,
                labelsStyle: kTextStyle14Bold.copyWith(color: cs.surface),
                speedDialChildren: [
                  SpeedDialChild(
                    //show a snack bar if user is logged in
                    child: const Icon(Icons.favorite),
                    foregroundColor: cs.surface,
                    backgroundColor: Colors.redAccent,
                    label: "add to wishlist".tr,
                    onPressed: () {
                      //add to db
                    },
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.star),
                    foregroundColor: cs.surface,
                    backgroundColor: Colors.amberAccent,
                    label: "rate the product".tr,
                    onPressed: () {
                      Get.defaultDialog(
                        title: "give a rate".tr,
                        titleStyle: kTextStyle24.copyWith(color: cs.primary),
                        content: Column(
                          children: [
                            RatingBar.builder(
                              initialRating: 0, //show the user previous rating
                              glow: false,
                              itemSize: 25,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                //do nothing
                              },
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () {
                                //send to db
                                Get.back();
                              },
                              child: Text(
                                "submit".tr,
                                style: kTextStyle18.copyWith(color: cs.primary),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SpeedDialChild(
                    closeSpeedDialOnPressed: false,
                    child: !con.cart.containsKey(product.id)
                        ? const Icon(Icons.add_shopping_cart)
                        : const Icon(Icons.remove_shopping_cart),
                    foregroundColor: cs.surface,
                    backgroundColor: Colors.blueAccent,
                    label: !con.cart.containsKey(product.id) ? "add to cart".tr : "remove from cart".tr,
                    onPressed: () {
                      !con.cart.containsKey(product.id) ? con.addToCart(product) : con.removeFromCart(product);
                      con.cart.containsKey(product.id)
                          ? Get.showSnackbar(GetSnackBar(
                              messageText: Text(
                                "added to cart".tr,
                                textAlign: TextAlign.center,
                                style: kTextStyle14.copyWith(color: Colors.white),
                              ),
                              backgroundColor: Colors.grey.shade800,
                              duration: const Duration(milliseconds: 800),
                              borderRadius: 30,
                              maxWidth: 150,
                              margin: const EdgeInsets.only(bottom: 50),
                            ))
                          : Get.showSnackbar(GetSnackBar(
                              messageText: Text(
                                "removed from cart".tr,
                                textAlign: TextAlign.center,
                                style: kTextStyle14.copyWith(color: Colors.white),
                              ),
                              backgroundColor: Colors.grey.shade800,
                              duration: const Duration(milliseconds: 800),
                              borderRadius: 30,
                              maxWidth: 150,
                              margin: const EdgeInsets.only(bottom: 50),
                            ));
                    },
                  ),
                ],
                closedForegroundColor: cs.onPrimary,
                openForegroundColor: cs.primary,
                closedBackgroundColor: cs.primary,
                openBackgroundColor: Get.isDarkMode ? cs.onPrimary : Colors.grey.shade200,
                child: const Icon(Icons.add),
              );
            }),
        backgroundColor: cs.background,
        appBar: AppBar(
          backgroundColor: cs.surface,
          centerTitle: true,
          title: Text(
            "product details".tr,
            style: kTextStyle26.copyWith(color: cs.onSurface),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: Hero(
                      tag: heroTag,
                      //todo:make pic sliver
                      child: Image.network(
                        product.image,
                        fit: BoxFit.fill,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width / 2,
                                child: SpinKitPouringHourGlass(
                                  color: cs.onBackground,
                                  size: 100,
                                  duration: const Duration(milliseconds: 1000),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: cs.surface,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: kTextStyle30Bold.copyWith(color: cs.onSurface),
                    ),
                    Divider(
                      height: 30,
                      thickness: 3,
                      color: cs.primary,
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Text(
                            "rating".tr,
                            style: kTextStyle30.copyWith(color: cs.onSurface),
                          ),
                          const SizedBox(width: 30),
                          Icon(
                            Icons.fiber_new_outlined,
                            color: cs.error,
                            size: 50,
                          ),
                        ],
                      ),
                      leading: Icon(
                        Icons.star,
                        color: cs.onSurface,
                        size: 30,
                      ),
                      subtitle: Row(
                        children: [
                          RatingBar.builder(
                            ignoreGestures: true,
                            initialRating: product.rating.rate,
                            glow: false,
                            itemSize: 20,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              //
                            },
                          ),
                          Text(
                            "(${product.rating.count.toString()})",
                            style: kTextStyle20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.label_sharp,
                        size: 30,
                      ),
                      title: Text(
                        "details".tr,
                        style: kTextStyle30.copyWith(color: cs.onSurface),
                      ),
                      subtitle: Text(
                        "click for details".tr,
                        style: kTextStyle16,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            product.description,
                            style: kTextStyle18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      title: Text(
                        "${product.price.toString()} \$",
                        style: kTextStyle50.copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
