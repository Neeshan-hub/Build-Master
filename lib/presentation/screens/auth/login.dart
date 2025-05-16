import 'package:bot_toast/bot_toast.dart';
import 'package:construction/bloc/auth/auth_bloc.dart';
import 'package:construction/data/models/users.dart';
import 'package:construction/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/carbon.dart';

import '../../../bloc/hidepassword/hidepassword_cubit.dart';
import '../../../main.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }
  //
  // TextEditingController usernameController =
  //     TextEditingController(text: "testsupervisor1@gmail.com");
  // TextEditingController passwordController =
  //     TextEditingController(text: "testsupervisor1@gmail.com");

  // TextEditingController usernameController =
  //     TextEditingController(text: "testengineer1@gmail.com");
  // TextEditingController passwordController =
  //     TextEditingController(text: "testengineer1@gmail.com");
  //
  // //
  TextEditingController usernameController =
  TextEditingController(text: "nishan@admin.com");
  TextEditingController passwordController =
  TextEditingController(text: "nishan@admin.com");

  final GlobalKey<FormState> _formkey = GlobalKey();
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // Background Gradient
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: size.height * 0.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.blue,
                    AppColors.blue.withOpacity(0.8),
                  ],
                ),
              ),
            ),

            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.15),

                  // Logo & Title
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 15,
                              spreadRadius: 3,
                            )
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Build Master",
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Log in to your account",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),

                  // Login Form Container
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 15),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          // Email Field
                          TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Iconify(
                                  AntDesign.user_outlined,
                                  size: 20,
                                  color: AppColors.blue,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.blue,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                            ),
                            validator: (value) =>
                                Validator.getEmailValidator(value),
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 20),

                          // Password Field
                          BlocBuilder<HidepasswordCubit, HidepasswordState>(
                            builder: (context, state) {
                              return TextFormField(
                                controller: passwordController,
                                obscureText: state.hidepassword,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Iconify(
                                      Carbon.password,
                                      size: 20,
                                      color: AppColors.blue,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(state.hidepassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      context
                                          .read<HidepasswordCubit>()
                                          .hidepassword(state.hidepassword);
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppColors.blue,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                ),
                                validator: (value) =>
                                    Validator.getPasswordValidator(value),
                                style: theme.textTheme.bodyLarge,
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Remember Me & Forgot Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    activeColor: AppColors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value!;
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  Text(
                                    "Remember me",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(forgotpassword);
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Sign In Button
                          BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is LoginLoadingState) {
                                BotToast.showCustomLoading(
                                  toastBuilder: (_) => customLoading(size),
                                );
                              }
                              if (state is CompletedLoadingState) {
                                BotToast.closeAllLoading();
                                Navigator.of(context).pushReplacementNamed(dashboard);
                              }
                              if (state is UserNotFountState) {
                                BotToast.closeAllLoading();
                                BotToast.showText(
                                  text: "Invalid Email Address",
                                  contentColor: AppColors.red,
                                );
                              }
                              if (state is InvalidPasswordState) {
                                BotToast.closeAllLoading();
                                BotToast.showText(
                                  text: "Invalid Password",
                                  contentColor: AppColors.red,
                                );
                              }
                              if (state is LoginFailedState) {
                                BotToast.closeAllLoading();
                                BotToast.showText(
                                  text: state.error, // Display the error message from LoginFailedState
                                  contentColor: AppColors.red,
                                );
                              }
                            },
                            builder: (context, state) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.blue,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                    shadowColor: AppColors.blue.withOpacity(0.4),
                                  ),
                                  onPressed: () {
                                    if (_formkey.currentState!.validate()) {
                                      UserModel userModel = UserModel(
                                        email: usernameController.text,
                                        password: passwordController.text,
                                      );
                                      BlocProvider.of<AuthBloc>(context).signInWithEmail(userModel);
                                    }
                                  },
                                  child: Text(
                                    "Log In",
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Sign Up Option
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // navigate to sign up
                                },
                                child: Text(
                                  "Sign Up",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
