import 'package:flutter/material.dart';

import '../../logic/bloc.dart';
import '../../routes/router.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomeView"),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(20),
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          late String title;
          late IconData icon;
          late VoidCallback onTap;

          switch (index) {
            case 0:
              title = 'Add Product';
              icon = Icons.post_add_outlined;
              onTap = () => context.goNamed(RouterName.addProduct);
              break;
            case 1:
              title = 'Products';
              icon = Icons.list_alt_outlined;
              onTap = () => context.goNamed(RouterName.products);
              break;
            case 2:
              title = 'QR Code';
              icon = Icons.qr_code_2_outlined;
              onTap = () {};
              break;
            case 3:
              title = 'Catalog';
              icon = Icons.document_scanner_outlined;
              onTap = () {};
              break;
          }

          return Material(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon),
                  SizedBox(height: 10),
                  Text(title),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<AuthBloc>().add(AuthEventLogout()),
        child: Icon(Icons.logout_outlined),
      ),
    );
  }
}
