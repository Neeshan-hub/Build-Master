import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TotalItemsPage extends StatelessWidget {
  final String siteId;
  final String siteName;

  const TotalItemsPage(
      {super.key, required this.siteId, required this.siteName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recent Site Orders')), // App bar title
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Divider under the app bar title
          const Divider(
            thickness: 4,
            color: Colors.yellow, // Customize the divider color
          ),

          // Site Name (displayed below the divider)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              siteName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Body content (stocks table)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0), // Even padding on both sides
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection("sites")
                    .doc(siteId)
                    .collection("stocks")
                    .get(), // Fetch stocks data
                builder: (context, stockSnapshot) {
                  if (stockSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (stockSnapshot.hasError) {
                    return const Center(child: Text("Error loading stocks"));
                  }

                  if (!stockSnapshot.hasData ||
                      stockSnapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No stocks available"));
                  }

                  final stocks = stockSnapshot.data!.docs;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20.0,
                      border: TableBorder.all(width: 1, color: Colors.grey),
                      columns: const [
                        DataColumn(
                            label: Expanded(
                                child: Center(
                                    child: Text('S.N.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))))),
                        DataColumn(
                            label: Expanded(
                                child: Center(
                                    child: Text('Material Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))))),
                        DataColumn(
                            label: Expanded(
                                child: Center(
                                    child: Text('Quantity',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))))),
                        DataColumn(
                            label: Expanded(
                                child: Center(
                                    child: Text('Total Cost',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))))),
                      ],
                      rows: stocks.map((stock) {
                        final data = stock.data()
                            as Map<String, dynamic>?; // Ensure it's a Map
                        final String itemName =
                            data?['itemname'] ?? 'Unknown Item';
                        final double quantity =
                            (data?['quantity'] ?? 0.0).toDouble();
                        final double unitCost = (data?['unitCost'] ?? 0.0)
                            .toDouble(); // Assuming unitCost is in your stock data.

                        // Calculate the total cost
                        double totalCost = quantity * unitCost;

                        return DataRow(cells: [
                          DataCell(Center(
                              child: Text((stocks.indexOf(stock) + 1)
                                  .toString()))), // Serial Number (S.N.)
                          DataCell(Center(child: Text(itemName))),
                          DataCell(Center(child: Text(quantity.toString()))),
                          DataCell(Center(
                              child: Text(totalCost
                                  .toStringAsFixed(2)))), // Display Total Cost
                        ]);
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
