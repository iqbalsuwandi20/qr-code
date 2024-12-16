import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code/logic/bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/product.dart';

class DetailProductView extends StatelessWidget {
  DetailProductView(this.id, this.product, {super.key});

  final String id;
  final Product product;

  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    codeController.text = product.code!;
    nameController.text = product.name!;
    quantityController.text = product.qty!.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Product",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.06,
            color: Colors.white70,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Icon(
              Icons.arrow_back_ios_new,
              key: ValueKey<int>(1),
              color: Colors.white70,
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
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
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 5,
                        ),
                      ),
                      child: QrImageView(
                        data: product.code!,
                        size: MediaQuery.of(context).size.width * 0.5,
                        version: QrVersions.auto,
                        backgroundColor: Colors.white70,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                TextField(
                  controller: codeController,
                  readOnly: true,
                  maxLength: 5,
                  decoration: InputDecoration(
                    labelText: "Product Code",
                    labelStyle: GoogleFonts.poppins(color: Colors.white70),
                    icon: const AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        Icons.vpn_key_outlined,
                        color: Colors.white70,
                        key: ValueKey<int>(1),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    counterStyle: const TextStyle(color: Colors.white),
                  ),
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextField(
                  controller: nameController,
                  autocorrect: false,
                  readOnly: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Product Name",
                    labelStyle: GoogleFonts.poppins(color: Colors.white70),
                    icon: const AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        Icons.label_outline,
                        color: Colors.white70,
                        key: ValueKey<int>(1),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextField(
                  controller: quantityController,
                  autocorrect: false,
                  readOnly: true,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  decoration: InputDecoration(
                    labelText: "Quantity",
                    labelStyle: GoogleFonts.poppins(color: Colors.white70),
                    icon: const AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        Icons.format_list_numbered_outlined,
                        color: Colors.white70,
                        key: ValueKey<int>(1),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    counterStyle: const TextStyle(color: Colors.white),
                  ),
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.blueAccent,
                //     padding: EdgeInsets.symmetric(
                //       vertical: MediaQuery.of(context).size.height * 0.02,
                //       horizontal: MediaQuery.of(context).size.width * 0.2,
                //     ),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(15),
                //     ),
                //   ),
                //   onPressed: () {
                //     if (nameController.text.isEmpty &&
                //         quantityController.text.isEmpty) {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(content: Text('Data cannot be empty')),
                //       );
                //     }
                //     if (quantityController.text.length == 5) {
                //       context.read<ProductBloc>().add(ProductEventEditProduct(
                //             productId: product.productId!,
                //             name: nameController.text,
                //             qty: int.tryParse(quantityController.text) ?? 0,
                //           ));
                //     } else {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //             content: Text('Quantity must be 5 digits')),
                //       );
                //     }
                //   },
                //   child: BlocConsumer<ProductBloc, ProductState>(
                //     listener: (context, state) {
                //       if (state is ProductStateError) {
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(content: Text(state.message)),
                //         );
                //       }
                //       if (state is ProductStateCompleteEdit) {
                //         context.pop();
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           const SnackBar(
                //               content: Text("Successfully updated product")),
                //         );
                //       }
                //     },
                //     builder: (context, state) {
                //       return Text(
                //         state is ProductStateLoadingEdit
                //             ? 'LOADING...'
                //             : 'UPDATE',
                //         style: GoogleFonts.poppins(
                //           fontSize: MediaQuery.of(context).size.width * 0.05,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.white70,
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextButton(
                  onPressed: () {
                    context
                        .read<ProductBloc>()
                        .add(ProductEventDeleteProduct(product.productId!));
                  },
                  child: BlocConsumer<ProductBloc, ProductState>(
                    listener: (context, state) {
                      if (state is ProductStateError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                      if (state is ProductStateCompleteDelete) {
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Successfully deleted product")),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Text(
                        state is ProductStateLoadingDelete
                            ? 'LOADING...'
                            : 'DELETE PRODUCT',
                        style: GoogleFonts.poppins(
                          color: Colors.red[300],
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
