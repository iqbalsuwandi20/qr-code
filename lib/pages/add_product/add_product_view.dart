import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../logic/bloc.dart';

class AddProductView extends StatelessWidget {
  AddProductView({super.key});

  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add New Product",
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
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add a New Product',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  TextField(
                    controller: codeController,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    decoration: InputDecoration(
                      labelText: "Product Code",
                      labelStyle: GoogleFonts.poppins(color: Colors.white70),
                      prefixIcon: const AnimatedSwitcher(
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
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Product Name",
                      labelStyle: GoogleFonts.poppins(color: Colors.white70),
                      prefixIcon: const AnimatedSwitcher(
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
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    decoration: InputDecoration(
                      labelText: "Quantity",
                      labelStyle: GoogleFonts.poppins(color: Colors.white70),
                      prefixIcon: const AnimatedSwitcher(
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02,
                        horizontal: MediaQuery.of(context).size.width * 0.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      if (codeController.text.isEmpty &&
                          nameController.text.isEmpty &&
                          quantityController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Data cannot be empty')),
                        );
                        return;
                      }
                      if (codeController.text.length == 5 &&
                          quantityController.text.length == 5) {
                        context.read<ProductBloc>().add(ProductEventAddProduct(
                              code: codeController.text,
                              name: nameController.text,
                              qty: int.tryParse(quantityController.text) ?? 0,
                            ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Product Code and Quantity must be 5 digits',
                            ),
                          ),
                        );
                      }
                    },
                    child: BlocConsumer<ProductBloc, ProductState>(
                      listener: (context, state) {
                        if (state is ProductStateError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                        if (state is ProductStateCompleteAdd) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Product added successfully!"),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Text(
                          state is ProductStateLoadingAdd
                              ? 'LOADING..'
                              : 'ADD PRODUCT',
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
