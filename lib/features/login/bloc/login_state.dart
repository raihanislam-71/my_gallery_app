import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.message = '',
    this.isLoading = false,
    this.isAuthenticated = false,
  });

  final String email;
  final String password;
  final String message;
  final bool isLoading;
  final bool isAuthenticated;

  LoginState copyWith({
    String? email,
    String? password,
    String? message,
    bool? isLoading,
    bool? isAuthenticated,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      message: message ?? '',
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  @override
  List<Object?> get props => [email, password, message, isLoading, isAuthenticated];
}
