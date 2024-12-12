import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        emit(ProductStateLoading());
        var result = await firestore.collection('products').add({
          "name": event.name,
          "code": event.code,
          "qty": event.qty,
        });
        await firestore
            .collection('products')
            .doc(result.id)
            .update({'productId': result.id});
        emit(ProductStateComplete());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message.toString()));
      } catch (e) {
        emit(ProductStateError(e.toString()));
      }
    });
    on<ProductEventEditProduct>((event, emit) {
      // TODO: implement event handler
    });
    on<ProductEventDeleteProduct>((event, emit) {
      // TODO: implement event handler
    });
  }
}
