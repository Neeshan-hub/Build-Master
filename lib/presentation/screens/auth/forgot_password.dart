import 'package:bot_toast/bot_toast.dart';
import 'package:construction/bloc/forgotpassword/forgot_password_bloc.dart';
import 'package:construction/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/validator.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController usernameController =
      TextEditingController(text: "nishan@admin.com");
  final GlobalKey<FormState> _formkey = GlobalKey();
  bool _isEmailHovered = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // Animated Gradient Background
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

            // Floating Particles (Optional decorative elements)
            Positioned(
              top: size.height * 0.1,
              right: 30,
              child: _buildFloatingCircle(15, Colors.white.withOpacity(0.1)),
            ),
            Positioned(
              top: size.height * 0.25,
              left: 20,
              child: _buildFloatingCircle(10, Colors.white.withOpacity(0.1)),
            ),

            // Main content
            SingleChildScrollView(
              child: SizedBox(
                height: size.height,
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.1),

                    // Logo and Title with Animation
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                        key: const ValueKey('logo-title'),
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            "Reset Password",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "We'll send a reset link to your email",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Form Card with Neumorphic Effect
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 40),
                        padding: const EdgeInsets.only(
                          top: 40,
                          left: 24,
                          right: 24,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isDarkMode ? Colors.grey[900] : Colors.grey[50],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Email Field with Floating Label
                              MouseRegion(
                                onEnter: (_) =>
                                    setState(() => _isEmailHovered = true),
                                onExit: (_) =>
                                    setState(() => _isEmailHovered = false),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  transform: Matrix4.identity()
                                    ..scale(_isEmailHovered ? 1.01 : 1.0),
                                  child: TextFormField(
                                    controller: usernameController,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.grey[800],
                                    ),
                                    decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelText: "Email Address",
                                      labelStyle: TextStyle(
                                        color: AppColors.blue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Iconify(
                                          AntDesign.mail_outlined,
                                          size: 24,
                                          color: _isEmailHovered
                                              ? AppColors.blue
                                              : Colors.grey[600],
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: isDarkMode
                                          ? Colors.grey[800]!.withOpacity(0.7)
                                          : Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppColors.blue,
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 18,
                                        horizontal: 16,
                                      ),
                                    ),
                                    validator: (value) =>
                                        Validator.getEmailValidator(value),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 40),

                              // Send Reset Link Button with Loading State
                              BlocConsumer<ForgotPasswordBloc,
                                  ForgotPasswordState>(
                                listener: (context, state) {
                                  if (state
                                      is SendPasswordResetLinkLoadingState) {
                                    BotToast.showCustomLoading(
                                      toastBuilder: (cn) => customLoading(size),
                                    );
                                  }
                                  if (state
                                      is SendPasswordResetLinkCompletedState) {
                                    BotToast.closeAllLoading();
                                    BotToast.showText(
                                        text: state.successMessage);
                                    usernameController.clear();
                                  }
                                  if (state
                                      is SendPasswordResetLinkErrorState) {
                                    BotToast.closeAllLoading();
                                    BotToast.showText(
                                      text: state.errorMessage,
                                      contentColor: AppColors.red,
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: 52,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.blue,
                                          AppColors.blue.withOpacity(0.8),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        if (state
                                            is! SendPasswordResetLinkLoadingState)
                                          BoxShadow(
                                            color:
                                                AppColors.blue.withOpacity(0.3),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 4),
                                          ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: state
                                                is SendPasswordResetLinkLoadingState
                                            ? null
                                            : () {
                                                if (_formkey.currentState!
                                                    .validate()) {
                                                  BlocProvider.of<
                                                              ForgotPasswordBloc>(
                                                          context)
                                                      .add(
                                                    SendResetPasswordLinkEvent(
                                                      email: usernameController
                                                          .text
                                                          .trim(),
                                                    ),
                                                  );
                                                }
                                              },
                                        child: Center(
                                          child: state
                                                  is SendPasswordResetLinkLoadingState
                                              ? const SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : Text(
                                                  "Send Reset Link",
                                                  style: theme
                                                      .textTheme.titleMedium
                                                      ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),

                              const Spacer(),

                              // Back to Login with smooth transition
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                        color: AppColors.blue,
                                        fontWeight: FontWeight.w600,
                                      ) ??
                                      TextStyle(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        size: 14,
                                        color: AppColors.blue,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Back to Login",
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppColors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingCircle(double size, Color color) {
    return AnimatedContainer(
      duration: const Duration(seconds: 10),
      curve: Curves.easeInOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
