import 'package:flutter/material.dart';

import '../../logic/auth/auth_bloc.dart';
import '../../routes/router.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomeView"),
        centerTitle: true,
      ),
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthStateLogout) {
              context.goNamed(RouterName.home);
            }
          },
          builder: (context, state) {
            if (state is AuthStateLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is AuthStateError) {
              return Center(
                child: Text("Terjadi Kesalahan"),
              );
            }
            return Column(
              children: [
                Text('data'),
                Text('data'),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<AuthBloc>().add(AuthEventLogout()),
        child: Icon(Icons.logout_outlined),
      ),
    );
  }
}
