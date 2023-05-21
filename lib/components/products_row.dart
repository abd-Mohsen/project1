import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/components/product_card.dart';
import 'package:project1/models/product_model.dart';
import 'package:project1/views/full_view.dart';

import '../constants.dart';

class ProductsRow extends StatelessWidget {
  final String title;
  final String heroTag;
  final List<ProductModel> productsList;

  const ProductsRow({
    super.key,
    required this.title,
    required this.productsList,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: kTextStyle24Bold.copyWith(color: cs.onBackground),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Get.to(() => FullView(list: productsList, title: title));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "see more".tr,
                      style: kTextStyle16.copyWith(color: cs.onBackground, decoration: TextDecoration.underline),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: productsList
                  .sublist(0, productsList.length < 3 ? productsList.length - 1 : 4)
                  .map((product) => ProductCard(product, heroTag))
                  .toList(),

              ///to return the first 4 products
            ),
          ),
        ],
      ),
    );
  }
}
