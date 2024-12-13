import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code/logic/bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
          title: Text("Detail Product View"),
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: QrImageView(
                    data: product.code!,
                    size: 200,
                    version: QrVersions.auto,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: codeController,
              readOnly: true,
              maxLength: 5,
              decoration: InputDecoration(
                labelText: "Product Code",
                icon: Icon(Icons.code_off_outlined),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "Product Name",
                icon: Icon(Icons.production_quantity_limits_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: quantityController,
              autocorrect: false,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              maxLength: 5,
              decoration: InputDecoration(
                labelText: "Quantity",
                icon: Icon(Icons.production_quantity_limits_outlined),
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
                if (quantityController.text.length == 5) {
                  context.read<ProductBloc>().add(ProductEventEditProduct(
                        productId: product.productId!,
                        name: nameController.text,
                        qty: int.tryParse(quantityController.text) ?? 0,
                      ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Quantity harus wajib 5 karakter')));
                }
              },
              child: BlocConsumer<ProductBloc, ProductState>(
                listener: (context, state) {
                  if (state is ProductStateError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                  if (state is ProductStateCompleteEdit) {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Sukses Mengupdate Product")));
                  }
                },
                builder: (context, state) {
                  return Text(state is ProductStateLoadingEdit
                      ? 'LOADING..'
                      : 'UPDATE PRODUCT');
                },
              ),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<ProductBloc>()
                    .add(ProductEventDeleteProduct(product.productId!));
              },
              child: BlocConsumer<ProductBloc, ProductState>(
                listener: (context, state) {
                  if (state is ProductStateError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                  if (state is ProductStateCompleteDelete) {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Sukses Menghapus Product")));
                  }
                },
                builder: (context, state) {
                  return Text(state is ProductStateLoadingDelete
                      ? 'LOADING..'
                      : 'DELETE PRODUCT');
                },
              ),
            ),
          ],
        ));
  }
}
