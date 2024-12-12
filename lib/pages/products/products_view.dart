import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../logic/bloc.dart';
import '../../models/product.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    ProductBloc productBloc = context.read<ProductBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Products Views"),
      ),
      body: StreamBuilder<QuerySnapshot<Product>>(
        stream: productBloc.streamProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text("Tidak ada data"),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Tidak dapat mengambil data"),
            );
          }

          List<Product> allProducts = [];

          for (var element in snapshot.data!.docs) {
            allProducts.add(element.data());
          }

          if (allProducts.isEmpty) {
            return Center(
              child: Text("Tidak ada data"),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: allProducts.length,
            itemBuilder: (context, index) {
              Product product = allProducts[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {},
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.code!),
                              SizedBox(height: 10),
                              Text(product.name!),
                              SizedBox(height: 10),
                              Text('Total: ${product.qty.toString()}'),
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          child: QrImageView(
                            data: product.code!,
                            size: 200,
                            version: QrVersions.auto,
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
    );
  }
}
