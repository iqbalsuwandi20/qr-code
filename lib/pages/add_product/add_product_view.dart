import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        title: Text("Add Product View"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: codeController,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            maxLength: 5,
            decoration: InputDecoration(
              labelText: "Product Code",
              icon: Icon(Icons.code_off_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
              if (codeController.text.isEmpty &&
                  nameController.text.isEmpty &&
                  quantityController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data tidak boleh kosong')));
              }
              if (codeController.text.length == 5 &&
                  quantityController.text.length == 5) {
                context.read<ProductBloc>().add(ProductEventAddProduct(
                      code: codeController.text,
                      name: nameController.text,
                      qty: int.tryParse(quantityController.text) ?? 0,
                    ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Product Code dan Quantity harus wajib 5 angka')));
              }
            },
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
                if (state is ProductStateCompleteAdd) {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Sukes Menambah Product")));
                }
              },
              builder: (context, state) {
                return Text(state is ProductStateLoadingAdd
                    ? 'LOADING..'
                    : 'ADD PRODUCT');
              },
            ),
          ),
        ],
      ),
    );
  }
}
