import 'package:construction/bloc/auth/auth_bloc.dart';
import 'package:construction/bloc/sites/sites_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fluent_mdl2.dart';

import '../../utils/app_colors.dart';

class ShowCustomModal {
  showArchriveDialog({
    required String id,
    required BuildContext context,
    required double height,
    required double width,
    required double imageheight,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          final size = MediaQuery.of(context).size;
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: SizedBox(
              width: width,
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: size.width / 9.6,
                    backgroundColor: AppColors.blue,
                    child: Iconify(
                      FluentMdl2.archive_undo,
                      color: AppColors.white,
                      size: size.height / 90 * 4.76,
                    ),
                  ),
                  const Text(
                    "Are you sure you want to Archrive ?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: const Size(103, 33),
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.blue,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: const Size(103, 33),
                          backgroundColor: AppColors.blue,
                          foregroundColor: AppColors.white,
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Archrive",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  showDeleteDialog({
    required String id,
    required BuildContext context,
    required double height,
    required double width,
    required List<String> imageurl,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          final size = MediaQuery.of(context).size;
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: SizedBox(
              width: width,
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: size.width / 9.2,
                    backgroundColor: AppColors.red,
                    child: Iconify(
                      FluentMdl2.delete,
                      size: size.height / 90 * 4.76,
                      color: AppColors.white,
                    ),
                  ),
                  const Text(
                    "Are you sure you want to Delete ?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: const Size(103, 33),
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.blue,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: const Size(103, 33),
                          backgroundColor: AppColors.red,
                          foregroundColor: AppColors.white,
                        ),
                        onPressed: () {
                          BlocProvider.of<SitesBloc>(context)
                              .deleteSite(id, imageurl, context);
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  showSignOutDialog({
    required BuildContext context,
    required double height,
    required double width,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          final size = MediaQuery.of(context).size;
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: SizedBox(
              width: width,
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: size.width / 11,
                    backgroundColor: AppColors.red,
                    child: Iconify(
                      FluentMdl2.sign_out,
                      size: size.height / 90 * 3.2,
                      color: AppColors.white,
                    ),
                  ),
                  const Text(
                    "Are you sure you want to Sign Out ?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          minimumSize: const Size(
                              103, 33), // Allows the button to expand if needed
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          minimumSize: const Size(
                              103, 33), // Allows the button to expand if needed
                          backgroundColor: AppColors.red,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12), // Ensures padding inside button
                        ),
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context).signout(context);
                        },
                        child: const Text(
                          "Sign Out",
                          style: TextStyle(
                              fontSize: 14), // Adjust font size if needed
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
