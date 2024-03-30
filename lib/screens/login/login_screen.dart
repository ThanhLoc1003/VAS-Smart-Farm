import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vas_farm/config/router.dart';
import 'package:vas_farm/ultils/theme_ext.dart';

import '../../features/auth/bloc/auth_bloc.dart';

import '../../widgets/single_child_scroll_view_with_column.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _authState = context.read<AuthBloc>().state;
  late final _emailController = TextEditingController(
    text: (switch (_authState) {
      AuthLoginInitial(email: final email) => email,
      _ => '',
    }),
  );
  late final _passwordController = TextEditingController(
    text: (switch (_authState) {
      AuthLoginInitial(password: final password) => password,
      _ => '',
    }),
  );

  void _handleGo(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Truyền event cho bloc
      context.read<AuthBloc>().add(
            AuthLoginStarted(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  void _handleRetry(BuildContext context) {
    context.read<AuthBloc>().add(AuthStarted());
  }

  bool isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-z]+\.[a-z]+")
        .hasMatch(email);
  }

  Widget _buildInitialLoginWidget() {
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              autofillHints: const [AutofillHints.email],
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                } else if (!isEmailValid(value)) {
                  return 'Please enter valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _passwordController,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
              ),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                _handleGo(context);
              },
              label: const Text('Go'),
              icon: const Icon(Icons.arrow_forward),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                context.go(RouteName.register);
              },
              child: const Text('Don\'t have an account? Register'),
            ),
          ]
              .animate(
                interval: 50.ms,
              )
              .slideX(
                begin: -0.1,
                end: 0,
                curve: Curves.easeInOutCubic,
                duration: 400.ms,
              )
              .fadeIn(
                curve: Curves.easeInOutCubic,
                duration: 400.ms,
              ),
        ),
      ),
    );
  }

  Widget _buildInProgressLoginWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildFailureLoginWidget(String message) {
    return Column(
      children: [
        Text(
          message,
          style: context.text.bodyLarge!.copyWith(
            color: context.color.error,
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () {
            _handleRetry(context);
          },
          label: const Text('Retry'),
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    var loginWidget = (switch (authState) {
      // AuthInitial() => _buildInitialLoginWidget(),
      AuthAuthenticateUnauthenticated() => _buildInitialLoginWidget(),
      AuthLoginInProgress() => _buildInProgressLoginWidget(),
      AuthLoginFailure(message: final msg) => _buildFailureLoginWidget(msg),
      AuthLoginSuccess() => Container(),
      AuthLoginInitial() => _buildInitialLoginWidget(),
      _ => Container(),
    });

    loginWidget = BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthLoginSuccess():
              context.read<AuthBloc>().add(AuthAuthenticateStarted());
              break;
            case AuthAuthenticateSuccess():
              context.go(RouteName.home);
              break;
            default:
          }
        },
        child: loginWidget);

    return Scaffold(
      body: SingleChildScrollViewWithColumn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: context.text.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: context.color.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 48,
                  ),
                  decoration: BoxDecoration(
                    color: context.color.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: loginWidget),
            ),
          ],
        ),
      ),
    );
  }
}
