import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../models/product.dart';
import '../pages/add_product/add_product_view.dart';
import '../pages/detail_product/detail_product_view.dart';
import '../pages/error/error_view.dart';
import '../pages/home/home_view.dart';
import '../pages/login/login_view.dart';
import '../pages/products/products_view.dart';

export 'package:go_router/go_router.dart';

part 'router_name.dart';

final router = GoRouter(
  redirect: (context, state) {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return "/login";
    } else {
      return null;
    }
  },
  errorBuilder: (context, state) => const ErrorView(),
  routes: [
    GoRoute(
      path: '/',
      name: RouterName.home,
      builder: (context, state) => const HomeView(),
      routes: [
        GoRoute(
          path: 'products',
          name: RouterName.products,
          builder: (context, state) => const ProductsView(),
          routes: [
            GoRoute(
              path: ':detailProduct',
              name: RouterName.detailProduct,
              builder: (context, state) => DetailProductView(
                state.pathParameters['detailProduct'].toString(),
                state.extra as Product,
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'addProduct',
          name: RouterName.addProduct,
          builder: (context, state) => AddProductView(),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      name: RouterName.login,
      builder: (context, state) => LoginView(),
    ),
  ],
);
