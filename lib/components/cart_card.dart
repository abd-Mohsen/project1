import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/constants.dart';
import 'package:project1/controllers/cart_controller.dart';
import 'package:project1/models/product_model.dart';
import 'package:project1/views/product_view.dart';

class CartCard extends StatelessWidget {
  final ProductModel product;
  final int productCount;
  final VoidCallback deleteCallback;
  final VoidCallback increaseCallback;
  final VoidCallback decreaseCallback;

  const CartCard({
    super.key,
    required this.product,
    required this.deleteCallback,
    required this.increaseCallback,
    required this.decreaseCallback,
    required this.productCount,
  });
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    CartController cC = Get.find();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              ListTile(
                  tileColor: cs.surface,
                  leading: GestureDetector(
                    onTap: () {
                      Get.to(() => ProductView(product: product, heroTag: "cart${product.id}"));
                    },
                    child: Hero(
                      tag: "cart${product.id}",
                      child: Image.network(
                        product.image,
                      ),
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: kTextStyle18.copyWith(color: cs.onSurface),
                    ),
                  ),
                  trailing: CircleAvatar(
                    radius: 20,
                    backgroundColor: cs.primary,
                    child: IconButton(
                      onPressed: deleteCallback,
                      icon: Icon(
                        Icons.delete,
                        color: cs.onPrimary,
                        size: 25,
                      ),
                    ),
                  ),
                  subtitle: Text(product.category),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                  )),
              Container(
                decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius:
                        const BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: decreaseCallback,
                            icon: Icon(
                              Icons.remove,
                              color: cC.quantity[product.id]! == 1 ? cs.onSurface.withOpacity(0.3) : cs.primary,
                            ),
                          ),
                          Text(
                            productCount.toString(),
                            style: kTextStyle26.copyWith(color: cs.onSurface),
                          ),
                          IconButton(
                            onPressed: increaseCallback,
                            icon: Icon(
                              Icons.add,
                              color: cC.quantity[product.id]! == 3 ? cs.onSurface.withOpacity(0.3) : cs.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "${(product.price * productCount).toPrecision(2)}\$",
                        style: kTextStyle24Bold.copyWith(color: cs.onSurface),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
