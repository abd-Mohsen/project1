import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/constants.dart';
import 'package:project1/controllers/cart_controller.dart';
import '../components/cart_card.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartController cC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "cart".tr,
            style: kTextStyle24Bold.copyWith(color: cs.onSurface),
          ),
          backgroundColor: cs.surface,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: cs.onSurface),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Get.defaultDialog(
                    backgroundColor: cs.surface,
                    title: "how to use Cart".tr,
                    titleStyle: TextStyle(color: cs.primary, wordSpacing: 5, fontWeight: FontWeight.bold, fontSize: 25),
                    middleText: "cart instructions".tr,
                    middleTextStyle: kTextStyle18.copyWith(color: cs.onSurface),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          "ok",
                          style: kTextStyle20.copyWith(color: cs.primary),
                        ),
                      )
                    ],
                  );
                },
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 30,
                  color: cs.error,
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  if (cC.cart.isNotEmpty) {
                    Get.defaultDialog(
                      title: "clear cart?".tr,
                      titleStyle: kTextStyle30.copyWith(color: cs.error),
                      middleText: "by pressing ok your cart will be cleared".tr,
                      middleTextStyle: kTextStyle14.copyWith(color: cs.onSurface),
                      confirm: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            cC.clearCart();
                            Get.back();
                          },
                          child: Text(
                            "ok",
                            style: kTextStyle16.copyWith(color: cs.error),
                          ),
                        ),
                      ),
                      cancel: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            "cancel",
                            style: kTextStyle16.copyWith(color: cs.onSurface),
                          ),
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.delete,
                  size: 30,
                  color: cs.onSurface,
                )),
          ],
        ),
        backgroundColor: cs.background,
        body: GetBuilder<CartController>(
          builder: (con) => ListView.builder(
            itemCount: con.cart.length,
            itemBuilder: (context, i) => CartCard(
              product: con.cart.values.elementAt(i),
              deleteCallback: () {
                con.removeFromCart(con.cart.values.elementAt(i));
              },
              increaseCallback: () {
                con.increaseProductCount(con.cart.values.elementAt(i));
              },
              decreaseCallback: () {
                con.decreaseProductCount(con.cart.values.elementAt(i));
              },
              productCount: con.quantity[con.cart.values.elementAt(i).id]!,
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: cs.background,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: GestureDetector(
              onTap: () {
                cC.makeOrder();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: cs.primary,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "confirm".tr,
                        style: kTextStyle22.copyWith(color: cs.onPrimary),
                      ),
                      GetBuilder<CartController>(
                        builder: (con) => Text(
                          " (${con.totalPrice.toPrecision(2).toString()}\$) ",
                          style: kTextStyle22.copyWith(color: cs.onPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//todo: set an animation on delete
