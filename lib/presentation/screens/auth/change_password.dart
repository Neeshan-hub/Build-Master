import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/validator.dart';
import '../../includes/custom_clipper.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

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
                          "Enter your new password.",
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
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    hintText: "*******",
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Iconify(
                                        AntDesign.lock_filled,
                                        size: 16,
                                        color: AppColors.blue,
                                      ),
                                    ),
                                    errorStyle: TextStyle(color: AppColors.red),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.red, width: 1.5),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.red, width: 1.5),
                                    ),
                                  ),
                                  validator: (value) =>
                                      Validator.getPasswordValidator(value),
                                ),
                              ),
                              SizedBox(
                                height: size.height / 90 * 1.88,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: padding.top),
                                child: TextFormField(
                                    controller: confirmPasswordController,
                                    decoration: InputDecoration(
                                      hintText: "*******",
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Iconify(
                                          AntDesign.lock_filled,
                                          size: 16,
                                          color: AppColors.blue,
                                        ),
                                      ),
                                      errorStyle:
                                          TextStyle(color: AppColors.red),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.red, width: 1.5),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.red, width: 1.5),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (passwordController.text !=
                                          confirmPasswordController.text) {
                                        return "Password Doesnot Match";
                                      }
                                      return null;
                                    }),
                              ),
                              SizedBox(
                                height: size.height / 90 * 2.88,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.blue,
                                  fixedSize:
                                      Size(size.width / 1.33, size.height / 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formkey.currentState!.validate()) {}
                                },
                                child: const Text(
                                  "Change Password",
                                  style: TextStyle(color: Colors.white),
                                ),
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
