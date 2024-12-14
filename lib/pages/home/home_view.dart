import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../logic/bloc.dart';
import '../../routes/router.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.06,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
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
          GridView.builder(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: MediaQuery.of(context).size.width * 0.05,
              crossAxisSpacing: MediaQuery.of(context).size.width * 0.05,
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
                  onTap = () {
                    context
                        .read<ProductBloc>()
                        .add(ProductEventBarcodeScanner());

                    context.read<ProductBloc>().stream.listen((state) {
                      if (state is ProductStateCompleteBarcode) {
                        // ignore: use_build_context_synchronously
                        context.goNamed(
                          RouterName.detailProduct,
                          pathParameters: {
                            'detailProduct': state.product.productId!
                          },
                          extra: state.product,
                        );
                      } else if (state is ProductStateError) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    });
                  };
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
                color: Colors.white.withOpacity(0.9),
                elevation: 3,
                shadowColor: Colors.black45,
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (index == 3)
                          ? BlocConsumer<ProductBloc, ProductState>(
                              listener: (context, state) {},
                              builder: (context, state) {
                                if (state is ProductStateLoadingExport) {
                                  return const CircularProgressIndicator(
                                    color: Colors.blueAccent,
                                  );
                                }
                                return Icon(
                                  icon,
                                  size: MediaQuery.of(context).size.width * 0.1,
                                  color: Colors.blueAccent,
                                );
                              },
                            )
                          : Icon(
                              icon,
                              size: MediaQuery.of(context).size.width * 0.1,
                              color: Colors.blueAccent,
                            ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AuthBloc>().add(AuthEventLogout());
          context.goNamed(RouterName.login);
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(
          Icons.logout_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
