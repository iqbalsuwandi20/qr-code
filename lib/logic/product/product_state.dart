part of 'product_bloc.dart';

sealed class ProductState {}

class ProductStateInitial extends ProductState {}

class ProductStateLoadingAdd extends ProductState {}

class ProductStateLoadingEdit extends ProductState {}

class ProductStateLoadingDelete extends ProductState {}

class ProductStateLoadingExport extends ProductState {}

class ProductStateLoadingBarcode extends ProductState {}

class ProductStateCompleteAdd extends ProductState {}

class ProductStateCompleteEdit extends ProductState {}

class ProductStateCompleteDelete extends ProductState {}

class ProductStateCompleteExport extends ProductState {}

class ProductStateCompleteBarcode extends ProductState {
  final Product product;

  ProductStateCompleteBarcode(this.product);
}

class ProductStateError extends ProductState {
  ProductStateError(this.message);

  String message;
}
