import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../constants.dart';

class OrderCard extends StatelessWidget {
  OrderCard({Key? key}) : super(key: key);

  ///hardcoded cuz backend isn't ready yet

  final DateTime orderDate = DateTime(2023, 5, 15, 6, 9);
  final int orderNumber = 6696;
  final double totalPrice = 419.99;
  final int totalAmount = 6;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        backgroundColor: cs.surface,
        collapsedBackgroundColor: cs.surface,
        leading: Text(
          "#$orderNumber",
          style: kTextStyle16.copyWith(color: cs.onSurface.withOpacity(0.7)),
        ),
        title: Text(
          "${orderDate.year}/${orderDate.month}/${orderDate.day}\n${orderDate.hour}:${orderDate.minute} ",
          style: kTextStyle22.copyWith(color: cs.onSurface, fontWeight: FontWeight.w400),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: totalAmount > 1
              ? Text(
                  "$totalPrice\$ ($totalAmount ${"items".tr})",
                  style: kTextStyle16.copyWith(color: cs.onSurface.withOpacity(0.6)),
                )
              : Text(
                  "$totalPrice\$",
                  style: kTextStyle16.copyWith(color: cs.onSurface.withOpacity(0.6)),
                ),
        ),
        // trailing: CircleAvatar(
        //   radius: 20,
        //   backgroundColor: cs.primary,
        //   child: Icon(
        //     Icons.keyboard_arrow_down,
        //     color: cs.onPrimary,
        //     size: 25,
        //   ),
        // ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        collapsedShape: RoundedRectangleBorder(
          side: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        children: [
          Divider(
            color: cs.onSurface,
            thickness: 1,
            indent: MediaQuery.of(context).size.width / 7,
            endIndent: MediaQuery.of(context).size.width / 7,
          ),
          OrderSubCard(),
          OrderSubCard(),
          OrderSubCard(),
        ],
      ),
    );
  }
}

class OrderSubCard extends StatelessWidget {
  const OrderSubCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Image.network(
          "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: SpinKitRotatingCircle(
                  color: cs.primary,
                  size: 30,
                  duration: const Duration(milliseconds: 1000),
                ),
              );
            }
          },
        ),
        title: Text(
          "Backpack, Fits 15 Laptops",
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
        trailing: Text(
          "x2",
          style: kTextStyle20.copyWith(color: cs.onSurface),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            "69.9\$ x 2",
            style: kTextStyle16,
          ),
        ),
      ),
    );
  }
}
