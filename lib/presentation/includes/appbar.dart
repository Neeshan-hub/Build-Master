import 'package:construction/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppbar {
  final String title;
  final Color? bgcolor;
  final Color? titleColor; // Add this line
  final Widget leading;
  final List<Widget>? action;

  const CustomAppbar({
    required this.title,
    required this.leading,
    this.bgcolor,
    this.action,
    this.titleColor, // Add this line
  });

  customAppBar() {
    return Column(
      children: [
        AppBar(
          iconTheme: IconThemeData(color: AppColors.blue),
          automaticallyImplyLeading: false,
          leading: leading,
          backgroundColor: bgcolor ?? AppColors.blue, // Use bgcolor if provided
          centerTitle: true,
          title: Text(
            title,
            style: TextStyle(
              color: titleColor ?? AppColors.white, // Use titleColor here
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: action,
        ),
      ],
    );
  }
}
