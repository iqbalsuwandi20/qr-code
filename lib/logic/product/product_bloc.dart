import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../models/product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Product>> streamProducts() async* {
    yield* firestore
        .collection('products')
        .withConverter<Product>(
          fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJson(),
        )
        .snapshots();
  }

  ProductBloc() : super(ProductStateInitial()) {
    on<ProductEventAddProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingAdd());
        var result = await firestore.collection('products').add({
          "name": event.name,
          "code": event.code,
          "qty": event.qty,
        });
        await firestore
            .collection('products')
            .doc(result.id)
            .update({'productId': result.id});
        emit(ProductStateCompleteAdd());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message.toString()));
      } catch (e) {
        emit(ProductStateError(e.toString()));
      }
    });

    on<ProductEventEditProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingEdit());

        await firestore.collection('products').doc(event.productId).update({
          "name": event.name,
          "qty": event.qty,
        });
        emit(ProductStateCompleteEdit());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message.toString()));
      } catch (e) {
        emit(ProductStateError(e.toString()));
      }
    });

    on<ProductEventDeleteProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingDelete());
        await firestore.collection('products').doc(event.id).delete();
        emit(ProductStateCompleteDelete());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message.toString()));
      } catch (e) {
        emit(ProductStateError(e.toString()));
      }
    });

    on<ProductEventExportToPdf>((event, emit) async {
      try {
        emit(ProductStateLoadingExport());

        var querySnap = await firestore
            .collection('products')
            .withConverter<Product>(
              fromFirestore: (snapshot, _) =>
                  Product.fromJson(snapshot.data()!),
              toFirestore: (product, _) => product.toJson(),
            )
            .get();

        List<Product> allProducts = [];

        for (var element in querySnap.docs) {
          Product product = element.data();
          allProducts.add(product);
        }

        final pdf = pw.Document();

        var data = await rootBundle
            .load('assets/fonts/OpenSans_Condensed-Regular.ttf');
        var myFont = pw.Font.ttf(data);
        var myStyle = pw.TextStyle(font: myFont, fontSize: 25);

        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              List<pw.TableRow> allData = List.generate(
                allProducts.length,
                (index) {
                  Product product = allProducts[index];
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          '${index + 1}',
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          product.code!,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          product.name!,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.Text(
                          'Total: ${product.qty}',
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20),
                        child: pw.BarcodeWidget(
                          color: PdfColor.fromHex('#000000'),
                          data: product.code!,
                          barcode: pw.Barcode.qrCode(),
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ],
                  );
                },
              );

              return [
                pw.Center(
                  child: pw.Text('CATALOG PRODUCTS', style: myStyle),
                ),
                pw.SizedBox(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColor.fromHex('#000000'),
                    width: 3,
                  ),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(20),
                          child: pw.Text(
                            'No.',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(20),
                          child: pw.Text(
                            'Product Code',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(20),
                          child: pw.Text(
                            'Product Name',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(20),
                          child: pw.Text(
                            'Quantity',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(20),
                          child: pw.Text(
                            'Barcode',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...allData,
                  ],
                ),
              ];
            },
          ),
        );

        Uint8List bytes = await pdf.save();

        final directory = await getApplicationDocumentsDirectory();

        File file = File('${directory.path}/myproducts.pdf');

        await file.writeAsBytes(bytes);

        await OpenFile.open(file.path);

        emit(ProductStateCompleteExport());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message.toString()));
      } catch (e) {
        emit(ProductStateError(e.toString()));
      }
    });

    on<ProductEventBarcodeScanner>((event, emit) async {
      try {
        emit(ProductStateLoadingBarcode());

        String barcode = await FlutterBarcodeScanner.scanBarcode(
          '#000000',
          'CANCEL',
          true,
          ScanMode.BARCODE,
        );

        if (barcode == '-1') return;

        var snapshot = await firestore
            .collection('products')
            .where('code', isEqualTo: barcode)
            .withConverter<Product>(
              fromFirestore: (snapshot, _) =>
                  Product.fromJson(snapshot.data()!),
              toFirestore: (product, _) => product.toJson(),
            )
            .get();

        if (snapshot.docs.isNotEmpty) {
          var product = snapshot.docs.first.data();
          emit(ProductStateCompleteBarcode(product));
        } else {
          emit(ProductStateError('Product not found'));
        }
      } catch (e) {
        emit(ProductStateError(e.toString()));
      }
    });
  }
}
