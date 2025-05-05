import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/main.dart';
import 'package:construction/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/emojione_monotone.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:shimmer/shimmer.dart';
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
  Future<List<String?>> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return [docSnapshot.data()?['role'], docSnapshot.data()?['fullname']];
    }
    return [null, null];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: FutureBuilder<List<String?>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoading(size);
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final role = snapshot.data?[0] ?? 'Unknown';
          final fullname = snapshot.data?[1] ?? 'User';

          return Column(
            children: [
              SizedBox(
                height: size.height * 0.28,
                child: Stack(
                  children: [
                    _buildAppBarBackground(size, role, fullname),
                    Positioned(
                      top: 40,
                      right: 20,
                      child: Row(
                        children: [
                          _buildAppBarAction(
                            icon: role == "Admin"
                                ? Iconify(
                                    EmojioneMonotone.construction_worker,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.exit_to_app,
                                    color: Colors.white,
                                  ),
                            onPressed: role == "Admin"
                                ? () =>
                                    Navigator.pushNamed(context, settingspage)
                                : () => ShowCustomModal().showSignOutDialog(
                                      context: context,
                                      height: size.height * 0.25,
                                      width: size.width * 0.8,
                                    ),
                          ),
                          _buildAppBarAction(
                            icon: Iconify(
                              Zondicons.notification,
                              color: Colors.white,
                            ),
                            onPressed: () =>
                                Navigator.pushNamed(context, notifications),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                    _buildMainContent(size, theme, role, isDarkMode, fullname),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBarBackground(Size size, String role, String fullname) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.blue.withOpacity(0.9),
            AppColors.blue.withOpacity(0.7),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: size.height * 0.05,
            right: -30,
            child: _buildFloatingCircle(80, Colors.white.withOpacity(0.1)),
          ),
          Positioned(
            top: size.height * 0.15,
            left: -20,
            child: _buildFloatingCircle(50, Colors.white.withOpacity(0.08)),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: _buildVisitAllSitesButton(role),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),
                Text(
                  "Welcome Back,",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  fullname,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildRoleBadge(role),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(Size size, ThemeData theme, String role,
      bool isDarkMode, String fullname) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          _buildStatsGrid(size, isDarkMode),
          const SizedBox(height: 24),
          _buildSectionHeader("Recent Activities", Icons.construction),
          const SizedBox(height: 16),
          HorizontalSiteList(role: role, fullname: fullname),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(Size size, bool isDarkMode) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.9,
      children: [
        _buildStatItem(
          title: "Engineers",
          icon: "assets/icons/engineer.png",
          countStream: FirebaseFirestore.instance
              .collection("users")
              .where("role", isEqualTo: "Engineer")
              .snapshots(),
          color: AppColors.green,
          isDarkMode: isDarkMode,
        ),
        _buildStatItem(
          title: "Supervisors",
          icon: "assets/icons/supervisor.png",
          countStream: FirebaseFirestore.instance
              .collection("users")
              .where("role", isEqualTo: "Supervisor")
              .snapshots(),
          color: AppColors.yellow,
          isDarkMode: isDarkMode,
        ),
        _buildStatItem(
          title: "Sites",
          icon: "assets/icons/house.png",
          countStream:
              FirebaseFirestore.instance.collection("sites").snapshots(),
          color: AppColors.blue,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String title,
    required String icon,
    required Stream<QuerySnapshot<Map<String, dynamic>>> countStream,
    required Color color,
    required bool isDarkMode,
  }) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: countStream,
      builder: (context, snapshot) {
        final count = snapshot.data?.docs.length ?? 0;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              if (!isDarkMode)
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(icon, height: 40, color: color),
                Text(
                  title,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    "$count",
                    key: ValueKey<int>(count),
                    style: TextStyle(
                      color: color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVisitAllSitesButton(String role) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              AppColors.green.withOpacity(0.9),
              AppColors.green,
            ],
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () =>
              Navigator.pushNamed(context, site, arguments: {"role": role}),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: const [
                Text(
                  "Visit All Sites",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.blue, size: 28),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: Text(
            "View All",
            style: TextStyle(
              color: AppColors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
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

  Widget _buildShimmerLoading(Size size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            width: size.width,
            height: size.height * 0.28,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children: List.generate(
                      3,
                      (index) => Container(
                            margin: const EdgeInsets.all(8),
                            height: 100,
                            color: Colors.white,
                          )),
                ),
                const SizedBox(height: 32),
                Container(
                  height: 200,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarAction(
      {required Widget icon, required VoidCallback onPressed}) {
    return IconButton(
      icon: icon,
      onPressed: onPressed,
      splashRadius: 24,
      tooltip: 'Menu',
    );
  }
}
