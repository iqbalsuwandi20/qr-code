import 'package:flutter/material.dart';

import '../../logic/bloc.dart';
import '../../routes/router.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController emailController =
      TextEditingController(text: "test@gmail.com");
  final TextEditingController passwordController =
      TextEditingController(text: "test123");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LoginView"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: emailController,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              icon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: passwordController,
            autocorrect: false,
            textInputAction: TextInputAction.done,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              icon: Icon(Icons.lock_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 50),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              context.read<AuthBloc>().add(AuthEventLogin(
                    emailController.text,
                    passwordController.text,
                  ));
            },
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthStateLogin) {
                  context.goNamed(RouterName.home);
                }
                if (state is AuthStateError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is AuthStateLoading) {
                  return Text("LOADING..");
                }
                return Text("LOGIN");
              },
            ),
          ),
        ],
      ),
    );
  }
}
