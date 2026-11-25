import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/auth_controller.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc({AuthController? authController})
      : _authController = authController ?? AuthController(),
        super(const SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
  }

  final AuthController _authController;

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    final token = await _authController.getAccessToken();
    if (!emit.isDone) {
      if (token != null && token.isNotEmpty) {
        emit(SplashNavigateToHome(
          email: AuthController.userEmail ?? 'samimcse7@gmail.com',
        ));
      } else {
        emit(const SplashNavigateToLogin());
      }
    }
  }
}
