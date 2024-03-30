import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vas_farm/ultils/theme_ext.dart';

import '../../config/router.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../widgets/single_child_scroll_view_with_column.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: '');
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final _confirmPasswordController = TextEditingController(text: '');

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthRegisterStarted(
              email: _emailController.text,
              username: _usernameController.text,
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

  Widget _buildInitialRegisterWidget() {
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              autofillHints: const [AutofillHints.username],
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter username';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
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
                } else if (isEmailValid(value) == false) {
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
            TextFormField(
              controller: _confirmPasswordController,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                labelText: 'Confirm Password',
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
                  return 'Please enter confirm password';
                } else if (value != _passwordController.text) {
                  return 'Confirm password not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                _handleSubmit(context);
              },
              label: const Text('Submit'),
              icon: const Icon(Icons.arrow_forward),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                context.go(RouteName.login);
              },
              child: const Text('Already have an account? Login'),
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

  Widget _buildInProgressRegisterWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildFailureRegisterWidget(String message) {
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

    var registerWidget = (switch (authState) {
      // AuthInitial() => _buildInitialRegisterWidget(),
      AuthAuthenticateUnauthenticated() => _buildInitialRegisterWidget(),
      AuthRegisterInProgress() => _buildInProgressRegisterWidget(),
      AuthRegisterFailure(message: final msg) =>
        _buildFailureRegisterWidget(msg),
      AuthRegisterSuccess() => Container(),
      _ => Container(),
    });

    registerWidget = BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          context.go(RouteName.login);
          context.read<AuthBloc>().add(AuthLoginPrefilled(
                email: _emailController.text,
                password: _passwordController.text,
              ));
        }
      },
      child: registerWidget,
    );

    return Scaffold(
      body: SingleChildScrollViewWithColumn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Register new account',
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
                child: TextButton(
                    onPressed: () {
                      // _handleSubmit(context);
                    },
                    child: registerWidget),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
