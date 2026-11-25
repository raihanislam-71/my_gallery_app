import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_logo.dart';
import '../home/home_screen.dart';
import 'bloc/login_bloc.dart';
import 'bloc/login_event.dart';
import 'bloc/login_state.dart';
import 'widgets/login_input_field.dart';
import 'widgets/login_options_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          previous.message != current.message ||
          previous.isAuthenticated != current.isAuthenticated,
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          _showMessage(context, state.message);
        }
        if (state.isAuthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => HomeScreen(email: state.email.trim()),
            ),
          );
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: AppLogo(
                        size: 56,
                        backgroundColor: AppColors.primary,
                        iconColor: Colors.white,
                        showShadow: false,
                        cornerRadius: 18,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Log in to continue managing your tasks.',
                      style: TextStyle(
                        color: AppColors.mutedText,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 36),
                    _buildEmailField(context),
                    const SizedBox(height: 20),
                    _buildPasswordField(context),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _showMessage(
                          context,
                          'Password reset will be available after API setup.',
                        ),
                        style: _compactTextButtonStyle(),
                        child: const Text('Forgot password?'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return FilledButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<LoginBloc>()
                                        .add(const LoginSubmitted());
                                  }
                                },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(54),
                            elevation: 4,
                            shadowColor:
                                AppColors.primary.withValues(alpha: 0.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: state.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Login'),
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    LoginOptionsSection(
                      onAction: (message) => _showMessage(context, message),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return LoginInputField(
      label: 'Email',
      hint: 'name@email.com',
      prefixIcon: Icons.mail_outline,
      keyboardType: TextInputType.emailAddress,
      onChanged: (email) =>
          context.read<LoginBloc>().add(LoginEmailChanged(email)),
      validator: (value) => value == null || value.trim().isEmpty
          ? 'Enter your email'
          : null,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return LoginInputField(
      label: 'Password',
      hint: 'Enter your password',
      prefixIcon: Icons.lock_outline,
      isPassword: true,
      textInputAction: TextInputAction.done,
      onChanged: (password) =>
          context.read<LoginBloc>().add(LoginPasswordChanged(password)),
      validator: (value) =>
          value == null || value.isEmpty ? 'Enter your password' : null,
    );
  }

  ButtonStyle _compactTextButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      minimumSize: Size.zero,
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
