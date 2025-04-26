import 'package:construction/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/app_colors.dart';

class HorizontalSiteList extends StatelessWidget {
  const HorizontalSiteList({super.key});

  Future<String?> _getUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return docSnapshot.data()?['role'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("sites")
            .orderBy('lastActivity', descending: true) // Sort by last activity
            .snapshots(),
        builder: (context, siteSnapshot) {
          if (siteSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (siteSnapshot.hasError) {
            return const Center(child: Text("Error loading sites"));
          }

          if (!siteSnapshot.hasData || siteSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No sites available"));
          }

          final sites = siteSnapshot.data!.docs;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sites.length,
            itemBuilder: (context, index) {
              final siteData = sites[index].data() as Map<String, dynamic>;
              final String siteId = sites[index].id;
              final String siteName = siteData['sitename'] ?? 'Unknown Site';

              return SizedBox(
                width: 300,
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 12,
                  shadowColor: Colors.black.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          siteName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection("sites")
                                .doc(siteId)
                                .collection("stocks")
                                .orderBy('lastUpdated', descending: true)
                                .limit(5) // Limit to avoid fetching too much
                                .get(),
                            builder: (context, stockSnapshot) {
                              if (stockSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (stockSnapshot.hasError) {
                                return const Center(
                                    child: Text("Error loading stocks"));
                              }

                              if (!stockSnapshot.hasData ||
                                  stockSnapshot.data!.docs.isEmpty) {
                                return const Center(
                                    child: Text("No stocks available"));
                              }

                              final stocks = stockSnapshot.data!.docs;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: stocks.map((stock) {
                                  final stockData =
                                      stock.data() as Map<String, dynamic>;
                                  final String itemName =
                                      stockData['itemname'] ?? 'Unknown Item';
                                  final String quantity =
                                      stockData['quantity']?.toString() ?? '';

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          itemName,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        Text(
                                          quantity,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                        FutureBuilder<String?>(
                          future: _getUserRole(),
                          builder: (context, roleSnapshot) {
                            if (roleSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final role = roleSnapshot.data ?? 'Unknown';

                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    siteDesc,
                                    arguments: {
                                      "sid": siteData['sid'],
                                      "sitename": siteData['sitename'],
                                      "sitedesc": siteData['sitedesc'],
                                      "sitelocation": siteData['sitelocation'],
                                      "clientname": siteData['clientname'],
                                      "phone": siteData['phone'],
                                      "supervisor": siteData['supervisor'],
                                      "role": role,
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.blue,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Visit Site",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
