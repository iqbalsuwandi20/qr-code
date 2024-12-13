part of 'product_bloc.dart';

sealed class ProductState {}

class ProductStateInitial extends ProductState {}

class ProductStateLoadingAdd extends ProductState {}

class ProductStateLoadingEdit extends ProductState {}

class ProductStateLoadingDelete extends ProductState {}

class ProductStateCompleteAdd extends ProductState {}

class ProductStateCompleteEdit extends ProductState {}

class ProductStateCompleteDelete extends ProductState {}

class ProductStateError extends ProductState {
  ProductStateError(this.message);

  String message;
}
