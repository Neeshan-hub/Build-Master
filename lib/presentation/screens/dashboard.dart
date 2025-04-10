import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/main.dart';

import 'package:construction/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/emojione_monotone.dart';
import 'package:iconify_flutter/icons/zondicons.dart';

import '../../utils/routes.dart';
import '../includes/appbar.dart';
import '../includes/horizontal_site.dart';
import '../includes/show_modal.dart' show ShowCustomModal;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    String role = "";
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (QueryDocumentSnapshot<Map<String, dynamic>> element
                in snapshot.data!.docs) {
              role = element['role'];
            }
            return Column(
              children: [
                PreferredSize(
                  preferredSize: Size(size.width, size.height / 0 * 8.5),
                  child: CustomAppbar(
                    action: [
                      role == "Admin"
                          ? IconButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(settingspage);
                              },
                              icon: Iconify(
                                EmojioneMonotone.construction_worker,
                                color: AppColors.blue,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                ShowCustomModal().showSignOutDialog(
                                  context: context,
                                  height: size.height / 90 * 23,
                                  width: size.width / 2 * 11,
                                );
                              },
                              icon: Icon(
                                Icons.exit_to_app,
                                color: AppColors.blue,
                              )),
                      IconButton(
                        onPressed: () {},
                        icon: Iconify(
                          Zondicons.notification,
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                    leading: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: padding.top * 0.1),
                      child: Image.asset(
                        "assets/images/logo.png",
                      ),
                    ),
                    title: "BuildMaster",
                    bgcolor: AppColors.white,
                  ).customAppBar(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: padding.top * 0.4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height / 90 * 2.34,
                      ),
                      info(size),
                      SizedBox(
                        height: size.height / 90 * 2.34,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Recent Sites Activities",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black, // White text for contrast
                      ),
                    ),
                  ),
                ),
                HorizontalSiteList(),
                SizedBox(
                  height: size.height / 90 * 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(site, arguments: {"role": role});
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: padding.top * 0.4),
                    height: size.height / 90 * 7.86,
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: [
                          AppColors.green.withOpacity(0.7),
                          AppColors.green.withOpacity(0.8),
                          AppColors.green,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8.0,
                          color: AppColors.customWhite,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width / 8 * 1.2,
                        ),
                        Text(
                          "Go To Sites",
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        Image.asset("assets/icons/house.png"),
                        SizedBox(
                          width: size.width / 9 * 1.2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Builder(
                builder: (context) => customLoading(size),
              ),
            );
          }
        },
      ),
    );
  }

  Row info(Size size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("role", isEqualTo: "Engineer")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                height: size.height / 90 * 16,
                width: size.width / 9 * 2.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      AppColors.green.withOpacity(0.3),
                      AppColors.green.withOpacity(0.6),
                      AppColors.green.withOpacity(0.9),
                      AppColors.green,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: AppColors.customWhite,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      "assets/icons/engineer.png",
                      height: size.height / 90 * 6.5,
                    ),
                    Text(
                      "Total Engineer",
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    snapshot.data!.docs.isEmpty
                        ? Text(
                            "0",
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          )
                        : Text(
                            "${snapshot.data!.docs.length}",
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Builder(
                  builder: (context) => customLoading(size),
                ),
              );
            }
          },
        ),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("role", isEqualTo: "Supervisor")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                height: size.height / 90 * 16,
                width: size.width / 9 * 2.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      AppColors.yellow.withOpacity(0.3),
                      AppColors.yellow.withOpacity(0.6),
                      AppColors.yellow.withOpacity(0.9),
                      AppColors.yellow,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: AppColors.customWhite,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      "assets/icons/supervisor.png",
                      height: size.height / 90 * 6.5,
                    ),
                    Text(
                      "Total Supervisor",
                      style: TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    snapshot.data!.docs.isEmpty
                        ? Text(
                            "0",
                            style: TextStyle(
                              color: AppColors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          )
                        : Text(
                            "${snapshot.data!.docs.length}",
                            style: TextStyle(
                              color: AppColors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Builder(
                  builder: (context) => customLoading(size),
                ),
              );
            }
          },
        ),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("sites").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                height: size.height / 90 * 16,
                width: size.width / 9 * 2.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      AppColors.blue.withValues(alpha: 0.3),
                      AppColors.blue.withValues(alpha: 0.6),
                      AppColors.blue.withValues(alpha: 0.9),
                      AppColors.blue,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: AppColors.customWhite,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      "assets/icons/house.png",
                      height: size.height / 90 * 6.5,
                    ),
                    Text(
                      "Total Sites",
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    snapshot.data!.docs.isEmpty
                        ? Text(
                            "0",
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          )
                        : Text(
                            "${snapshot.data!.docs.length}",
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Builder(
                  builder: (context) => customLoading(size),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
