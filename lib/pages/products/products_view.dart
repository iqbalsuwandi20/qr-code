import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../logic/bloc.dart';
import '../../models/product.dart';
import '../../routes/router.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    ProductBloc productBloc = context.read<ProductBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Products",
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
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Product>>(
                  stream: productBloc.streamProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blueAccent,
                        ),
                      );
                    }

                    if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                          "No data available",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Unable to retrieve data",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }

                    List<Product> allProducts = [];

                    for (var element in snapshot.data!.docs) {
                      allProducts.add(element.data());
                    }

                    if (allProducts.isEmpty) {
                      return Center(
                        child: Text(
                          "No data available",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      itemCount: allProducts.length,
                      itemBuilder: (context, index) {
                        Product product = allProducts[index];
                        return Card(
                          color: Colors.white.withOpacity(0.1),
                          elevation: 5,
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.width * 0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              context.goNamed(
                                RouterName.detailProduct,
                                pathParameters: {
                                  'detailProduct': product.productId!,
                                },
                                extra: product,
                              );
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.05),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.code!,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.045,
                                          ),
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                        Text(
                                          product.name!,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.045,
                                          ),
                                          maxLines: 1,
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                        Text(
                                          'Total: ${product.qty.toString()}',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.15,
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
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
                                      size: MediaQuery.of(context).size.width *
                                          0.15,
                                      version: QrVersions.auto,
                                      backgroundColor: Colors.white70,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
