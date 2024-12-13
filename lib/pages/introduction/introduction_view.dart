import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../logic/bloc.dart';
import '../../routes/router.dart';

class IntroductionView extends StatelessWidget {
  const IntroductionView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SplashBloc>().add(SplashEventStart());

    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        FirebaseAuth auth = FirebaseAuth.instance;

        if (state is SplashStateComplete) {
          final currentPath =
              GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;

          if (auth.currentUser == null) {
            if (currentPath != '/login') {
              context.goNamed(RouterName.login);
            }
          } else {
            if (currentPath != '/') {
              context.goNamed(RouterName.home);
            }
          }
        }
      },
      child: Scaffold(
        body: Center(
          child: Lottie.asset(
            'assets/lotties/qr-splash.json',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
