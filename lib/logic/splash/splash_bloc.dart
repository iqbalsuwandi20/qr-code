import 'package:bloc/bloc.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashEventStart>((event, emit) async {
      try {
        emit(SplashStateLoading());
        await Future.delayed(const Duration(seconds: 5));
        emit(SplashStateComplete());
      } catch (e) {
        emit(SplashStateError(e.toString()));
      }
    });
  }
}
