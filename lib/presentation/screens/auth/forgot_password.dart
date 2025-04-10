import 'package:bot_toast/bot_toast.dart';
import 'package:construction/bloc/forgotpassword/forgot_password_bloc.dart';
import 'package:construction/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/validator.dart';
import '../../includes/custom_clipper.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController usernameController =
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
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: AppColors.blue,
          ),
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
                        SizedBox(
                          height: size.height / 90 * 1.2,
                        ),
                        Text(
                          "Enter your email to reset you password",
                          style: TextStyle(
                            color: AppColors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: size.height / 90 * 1.2,
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
                                height: size.height / 90 * 2.88,
                              ),
                              BlocConsumer<ForgotPasswordBloc,
                                  ForgotPasswordState>(
                                listener: (context, state) {
                                  if (state
                                      is SendPasswordResetLinkLoadingState) {
                                    BotToast.showCustomLoading(
                                      toastBuilder: (cn) {
                                        return customLoading(size);
                                      },
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
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.blue,
                                      fixedSize: Size(
                                          size.width / 1.33, size.height / 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formkey.currentState!.validate()) {
                                        BlocProvider.of<ForgotPasswordBloc>(
                                                context)
                                            .add(
                                          SendResetPasswordLinkEvent(
                                            email:
                                                usernameController.text.trim(),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text(
                                      "Verify",
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
