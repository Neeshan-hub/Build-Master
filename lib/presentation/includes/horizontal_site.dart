import 'package:construction/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      width: double.infinity, // Expands the horizontal space
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("sites").snapshots(),
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
              final String siteName = siteData['sitename'] ?? 'Unknown Site';

              return SizedBox(
                width: 300, // Increases the width of each site card
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 12, // Increased elevation for deeper shadow
                  shadowColor:
                      // ignore: deprecated_member_use
                      Colors.black.withOpacity(0.4), // Darker shadow color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12.0), // Rounded corners for the card
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          siteName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("sites")
                                .doc(sites[index].id)
                                .collection("stocks")
                                .snapshots(),
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
                                children: [
                                  ...stocks.map((stock) {
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
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                            quantity,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
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

                            return Align(
                              alignment: Alignment.bottomRight,
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
                                      "role":
                                          role, // Role fetched from FirebaseAuth
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: Text(
                                  "Total Items",
                                  style: TextStyle(
                                    color: Colors.black,
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
