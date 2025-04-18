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
import '../../includes/custom_clipper.dart';

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

  TextEditingController usernameController =
      TextEditingController(text: "nishan@admin.com");
  TextEditingController passwordController =
      TextEditingController(text: "nishan@admin.com");
  final GlobalKey<FormState> _formkey = GlobalKey();
  bool hidepassword = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return GestureDetector(
      onTap: () {
        FocusScopeNode cf = FocusScope.of(context);
        if (!cf.hasPrimaryFocus) {
          cf.unfocus();
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode cf = FocusScope.of(context);
          if (!cf.hasPrimaryFocus) {
            cf.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              Expanded(
                flex: 4,
                child: ClipPath(
                  clipper: CustomCurve(),
                  child: Container(
                    color: AppColors.blue,
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  color: Colors.grey[10],
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Build Master",
                          style: TextStyle(
                            color: AppColors.blue,
                            fontSize: 31,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Log in",
                          style: TextStyle(
                            color: AppColors.blue,
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height / 90 * 1.88,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: padding.top),
                                child: TextFormField(
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Iconify(
                                        AntDesign.user_outlined,
                                        size: 16,
                                        color: AppColors.blue,
                                      ),
                                    ),
                                  ),
                                  validator: (value) =>
                                      Validator.getEmailValidator(value),
                                ),
                              ),
                              SizedBox(
                                height: size.height / 90 * 1.88,
                              ),
                              BlocConsumer<HidepasswordCubit,
                                  HidepasswordState>(
                                listener: (context, state) {},
                                builder: (context, state) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: padding.top),
                                    child: TextFormField(
                                      controller: passwordController,
                                      obscureText: state.hidepassword,
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Iconify(
                                            Carbon.password,
                                            size: 16,
                                            color: AppColors.blue,
                                          ),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: state.hidepassword
                                              ? Icon(
                                                  Icons.visibility_off,
                                                  color: AppColors.blue,
                                                )
                                              : Icon(
                                                  Icons.visibility,
                                                  color: AppColors.blue,
                                                ),
                                          onPressed: () {
                                            BlocProvider.of<HidepasswordCubit>(
                                                    context)
                                                .hidepassword(
                                                    state.hidepassword);
                                          },
                                        ),
                                      ),
                                      validator: (value) =>
                                          Validator.getPasswordValidator(value),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: size.height / 90 * 0.88,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: padding.top * 0.6),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          activeColor: AppColors.blue,
                                          value: true,
                                          onChanged: (value) {},
                                        ),
                                        Text(
                                          "Remember me",
                                          style: TextStyle(
                                            color: AppColors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      child: Text(
                                        "Forgot Password ?",
                                        style: TextStyle(
                                          color: AppColors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(forgotpassword);
                                      },
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height / 90 * 1.88,
                              ),
                              BlocConsumer<AuthBloc, AuthState>(
                                listener: (context, state) {
                                  if (state is LoginLoadingState) {
                                    BotToast.showCustomLoading(
                                      toastBuilder: (cancelFunc) {
                                        return customLoading(size);
                                      },
                                    );
                                  }
                                  if (state is CompletedLoadingState) {
                                    BotToast.closeAllLoading();
                                    Navigator.of(context)
                                        .pushReplacementNamed(dashboard);
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
                                        contentColor: AppColors.red);
                                  }
                                },
                                builder: (context, state) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.blue,
                                      fixedSize: Size(
                                          size.width / 1.5, size.height / 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formkey.currentState!.validate()) {
                                        UserModel userModel = UserModel(
                                            email: usernameController.text,
                                            password: passwordController.text);
                                        BlocProvider.of<AuthBloc>(context)
                                            .signInWithEmail(userModel);
                                      }
                                    },
                                    child: const Text(
                                      "Sign In",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
