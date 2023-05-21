import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:project1/constants.dart';
import 'package:project1/controllers/cart_controller.dart';
import 'package:project1/models/product_model.dart';
import '../views/product_view.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final String productCardHeroTag; //unique hero tag for every card
  //todo: sales banner
  //todo:enhance search card
  const ProductCard(this.product, this.productCardHeroTag, {super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductView(product: product, heroTag: "product${product.id}$productCardHeroTag"));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 225,
            width: 175,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: cs.surface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 11,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        ),
                        child: Hero(
                          tag: "product${product.id}$productCardHeroTag",
                          child: Container(
                            color: Colors.white,
                            child: Image.network(
                              product.image, height: 50,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: SpinKitFadingCircle(
                                      color: cs.primary,
                                      size: 30,
                                      duration: const Duration(milliseconds: 1000),
                                    ),
                                  );
                                }
                              },
                              // fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(
                          Icons.fiber_new_sharp,
                          color: cs.error,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 2,
                          style: kTextStyle14.copyWith(fontWeight: FontWeight.w600, color: cs.onSurface),
                          overflow: TextOverflow.ellipsis,
                        ),
                        // RatingBar.builder(
                        //   ignoreGestures: true,
                        //   initialRating: product.rating.rate,
                        //   glow: false,
                        //   itemSize: 12,
                        //   minRating: 1,
                        //   direction: Axis.horizontal,
                        //   allowHalfRating: true,
                        //   itemCount: 5,
                        //   itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                        //   itemBuilder: (context, _) => const Icon(
                        //     Icons.star,
                        //     color: Colors.amber,
                        //   ),
                        //   onRatingUpdate: (rating) {},
                        // ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${product.price}',
                                  style: kTextStyle18Bold.copyWith(color: cs.onSurface),
                                ),
                                Text(
                                  '\$${(product.price * 1.2).toPrecision(1)}',
                                  style: kTextStyle14.copyWith(
                                    color: cs.error.withOpacity(0.8),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                            GetBuilder<CartController>(
                              init: CartController(),
                              builder: (con) => GestureDetector(
                                onTap: () {
                                  !con.cart.containsKey(product.id)
                                      ? con.addToCart(product)
                                      : con.removeFromCart(product);
                                  con.cart.containsKey(product.id)
                                      ? Fluttertoast.showToast(
                                          msg: "added to cart".tr,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey.shade800,
                                          textColor: Colors.white,
                                          fontSize: 12,
                                        )
                                      // ? Get.showSnackbar(GetSnackBar(
                                      //     messageText: Text(
                                      //       "added to cart".tr,
                                      //       textAlign: TextAlign.center,
                                      //       style: kTextStyle14.copyWith(color: Colors.white),
                                      //     ),
                                      //     backgroundColor: Colors.grey.shade800,
                                      //     duration: const Duration(milliseconds: 800),
                                      //     borderRadius: 30,
                                      //     maxWidth: 150,
                                      //     margin: const EdgeInsets.only(bottom: 50),
                                      //   ))
                                      : Fluttertoast.showToast(
                                          //todo: no localization!?
                                          msg: "removed from cart".tr,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey.shade800,
                                          textColor: Colors.white,
                                          fontSize: 12,
                                        );
                                },
                                child: CircleAvatar(
                                  backgroundColor: cs.primary,
                                  radius: 15,
                                  child: Icon(
                                    !con.cart.containsKey(product.id)
                                        ? Icons.add_shopping_cart
                                        : Icons.remove_shopping_cart,
                                    size: 18,
                                    color: !con.cart.containsKey(product.id) ? cs.onPrimary : Colors.red,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
