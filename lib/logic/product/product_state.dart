part of 'product_bloc.dart';

sealed class ProductState {}

class ProductStateInitial extends ProductState {}

class ProductStateLoading extends ProductState {}

class ProductStateComplete extends ProductState {}

class ProductStateError extends ProductState {
  ProductStateError(this.message);

  String message;
}
