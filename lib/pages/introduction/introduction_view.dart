import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lotties/qr-splash.json',
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    'Welcome to QR Apps',
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    'Your journey starts here',
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
