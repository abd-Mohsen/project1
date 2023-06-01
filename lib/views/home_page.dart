import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project1/constants.dart';
import 'package:search_page/search_page.dart';
import 'package:project1/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:project1/views/product_view.dart';
import '../components/animated_transition.dart';
import '../controllers/home_controller.dart';
import 'cart_page.dart';
import 'navigation_bar_entries/categories.dart';
import 'navigation_bar_entries/home.dart';
import 'navigation_bar_entries/settings.dart';

//todo: back button behavior
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    HomeController hC = Get.put(HomeController());

    List<Widget> bodies = [
      const Settings(),
      const Home(),
      const Categories(),
    ];

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        //elevation: 0,
        backgroundColor: cs.surface,
        title: Row(
          children: [
            Hero(
              tag: "logo",
              child: Image.asset(
                "assets/images/logo.png",
                height: 30,
                width: 30,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              "Ecommerce",
              style: kTextStyle20Bold.copyWith(color: cs.onSurface),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Badge(
              alignment: AlignmentDirectional.topStart,
              label: const Text("1"),
              child: Icon(Icons.notifications_none_outlined, size: 27, color: cs.onSurface),
            ),
            onPressed: () {
              hC.refreshAllProducts();
              //todo: make a notification page when back-end is ready
              //todo: flutter local notifications
            },
          ),
          IconButton(
            onPressed: () {
              if (hC.isFetched) {
                showSearch(
                  context: context,
                  delegate: SearchPage(
                    items: hC.productsList,
                    searchLabel: "Search products".tr,
                    suggestion: GetBuilder<HomeController>(builder: (con) {
                      return hC.searchHistory.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.history_toggle_off, size: 100, color: cs.onBackground),
                                  Text(
                                    'No history yet',
                                    style: kTextStyle24.copyWith(color: cs.background),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              itemCount: con.searchHistory.length,
                              itemBuilder: (context, i) {
                                final entry = con.searchHistory.entries.elementAt(i);
                                return ListTile(
                                  onTap: () {
                                    Get.to(ProductView(product: entry.value, heroTag: ""));
                                    con.removeFromHistory(entry.value);
                                    con.addToSearchHistory(entry.value);
                                  },
                                  leading: const Icon(Icons.history),
                                  title: Text(
                                    entry.value.title,
                                    maxLines: 1,
                                    style: kTextStyle14.copyWith(overflow: TextOverflow.ellipsis),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      con.removeFromHistory(entry.value);
                                    },
                                  ),
                                );
                              },
                            );
                    }),
                    failure: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 100, color: cs.onBackground),
                          Text(
                            'No products found',
                            style: kTextStyle24.copyWith(color: cs.onBackground),
                          ),
                        ],
                      ),
                    ),
                    filter: (product) => [
                      product.title,
                    ],
                    sort: (a, b) => a.compareTo(b),
                    builder: (product) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: ListTile(
                        //tileColor: cs.surface,
                        trailing: Image.network(
                          product.image,
                          height: 45,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: SpinKitFadingCircle(
                                  color: cs.onBackground,
                                  size: 20,
                                  duration: const Duration(milliseconds: 1000),
                                ),
                              );
                            }
                          },
                        ),
                        title: Text(product.title),
                        onTap: () {
                          Get.off(ProductView(product: product, heroTag: ""));
                          if (hC.searchHistory.containsKey(product.id)) {
                            hC.removeFromHistory(product);
                          }
                          hC.addToSearchHistory(product);
                        },
                      ),
                    ),
                  ),
                );
              }
            },
            icon: Icon(
              Icons.search,
              color: cs.onSurface,
              size: 27,
            ),
          ),
          //wrapped in a get builder to show how many products in cart
          GetBuilder<CartController>(
            init: CartController(),
            builder: (con) => Center(
              child: IconButton(
                icon: Badge(
                  backgroundColor: Colors.blueAccent,
                  label: Text(con.totalProductsAmount.toString()),
                  isLabelVisible: con.cart.isNotEmpty,
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: 27,
                    color: cs.onSurface,
                  ),
                ),
                onPressed: () {
                  if (hC.isFetched) {
                    Get.to(() => const CartPage());
                  }
                },
              ),
            ),
          ),
        ],
      ),

      //wrapped in get builder to change scaffold body based on index from navigation bar
      //used indexed stack to not rebuild every widget from scratch when changing scaffold body
      //fade indexed stack is indexed stack but with fade animation when changing scaffold body

      body: GetBuilder<HomeController>(
        builder: (con) => FadeIndexedStack(
          duration: const Duration(milliseconds: 150),
          index: con.selectedIndex,
          children: bodies,
        ),
      ),

      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(
            Icons.settings,
            color: !Get.isDarkMode ? Colors.black : cs.onSurface,
            size: 25,
          ),
          Icon(
            Icons.home,
            color: !Get.isDarkMode ? Colors.black : cs.onSurface,
            size: 25,
          ),
          Icon(
            Icons.list_sharp,
            color: !Get.isDarkMode ? Colors.black : cs.onSurface,
            size: 25,
          ),
        ],
        height: 50,
        index: hC.selectedIndex,
        backgroundColor: cs.background,
        color: !Get.isDarkMode ? Colors.grey.shade200 : cs.surface,
        animationDuration: const Duration(milliseconds: 150),
        onTap: (i) {
          hC.changeTab(i);
        },
      ),
    );
  }
}
