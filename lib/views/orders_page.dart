import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/order_card.dart';
import '../constants.dart';

//todo:implement orders search when backend is ready
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: cs.background,
          appBar: AppBar(
            title: Text(
              "my orders".tr,
              style: kTextStyle24.copyWith(color: cs.onSurface),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.access_time,
                    color: cs.onSurface,
                  ),
                  child: Text("pending".tr, style: kTextStyle14.copyWith(color: cs.onSurface)),
                ),
                Tab(
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: cs.onSurface,
                  ),
                  child: Text("canceled".tr, style: kTextStyle14.copyWith(color: cs.onSurface)),
                ),
                Tab(
                  icon: Icon(
                    Icons.done_all,
                    color: cs.onSurface,
                  ),
                  child: Text("completed".tr, style: kTextStyle14.copyWith(color: cs.onSurface)),
                ),
              ],
            ),
            backgroundColor: cs.surface,
          ),
          body: TabBarView(
            children: [
              ListView(
                children: [
                  const SizedBox(height: 8),
                  OrderCard(),
                  OrderCard(),
                  OrderCard(),
                ],
              ),
              ListView(
                children: [
                  const SizedBox(height: 8),
                  OrderCard(),
                ],
              ),
              ListView(
                children: [
                  const SizedBox(height: 8),
                  OrderCard(),
                  OrderCard(),
                  OrderCard(),
                  OrderCard(),
                  OrderCard(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
