import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/api_urls.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/auth_controller.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    NetworkCaller? networkCaller,
    AuthController? authController,
  })  : _networkCaller = networkCaller ?? NetworkCaller(),
        _authController = authController ?? AuthController(),
        super(const LoginState()) {
    on<LoginEmailChanged>(
      (event, emit) => emit(state.copyWith(email: event.email)),
    );
    on<LoginPasswordChanged>(
      (event, emit) => emit(state.copyWith(password: event.password)),
    );
    on<LoginSubmitted>(_onSubmitted);
  }

  final NetworkCaller _networkCaller;
  final AuthController _authController;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final email = state.email.trim();
    final password = state.password;

    if (email.isEmpty || password.isEmpty) {
      emit(state.copyWith(message: 'Please enter your email and password.'));
      return;
    }

    emit(state.copyWith(isLoading: true, message: ''));

    final response = await _networkCaller.postRequest(
      url: ApiUrls.login,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.isSuccess && response.responseData != null) {
      final data = response.responseData['data'];
      final token = data?['accessToken']?.toString() ?? data?['token']?.toString();

      if (token != null && token.isNotEmpty) {
        await _authController.saveAccessToken(token, email: email);
        emit(state.copyWith(isLoading: false, isAuthenticated: true));
        return;
      }
    }

    final errorMessage = response.errorMessage ??
        response.responseData?['message']?.toString() ??
        'Login failed. Please check credentials.';

    emit(state.copyWith(
      isLoading: false,
      message: errorMessage,
    ));
  }
}
