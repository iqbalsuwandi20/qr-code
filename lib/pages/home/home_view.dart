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
              onTap = () {
                context.read<ProductBloc>().add(ProductEventExportToPdf());
              };
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
                  (index == 3)
                      ? BlocConsumer<ProductBloc, ProductState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            if (state is ProductStateLoadingExport) {
                              return CircularProgressIndicator();
                            }
                            return SizedBox(
                              height: 50,
                              width: 50,
                              child: Icon(
                                icon,
                                size: 50,
                              ),
                            );
                          },
                        )
                      : SizedBox(
                          height: 50,
                          width: 50,
                          child: Icon(
                            icon,
                            size: 50,
                          ),
                        ),
                  SizedBox(height: 10),
                  Text(title),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AuthBloc>().add(AuthEventLogout());

          context.goNamed(RouterName.login);
        },
        child: Icon(Icons.logout_outlined),
      ),
    );
  }
}
