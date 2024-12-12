import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../pages/error/error_view.dart';
import '../pages/home/home_view.dart';
import '../pages/login/login_view.dart';

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
    ),
    GoRoute(
      path: '/login',
      name: RouterName.login,
      builder: (context, state) => LoginView(),
    ),
  ],
);
