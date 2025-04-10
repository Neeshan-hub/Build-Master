import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class StockSearchBar extends StatefulWidget {
  final String siteId;
  final FocusNode focusNode;

  const StockSearchBar({
    super.key,
    required this.siteId,
    required this.focusNode,
  });

  @override
  StockSearchBarState createState() => StockSearchBarState();
}

class StockSearchBarState extends State<StockSearchBar> {
  final TextEditingController searchController = TextEditingController();
  final Map<String, int> selectedStocks = {};

  Future<List<DocumentSnapshot>> _fetchStockSuggestions(String query) async {
    if (query.isEmpty) return [];

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("sites")
          .doc(widget.siteId)
          .collection("stocks")
          .where("itemname", isGreaterThanOrEqualTo: query)
          .where("itemname", isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return querySnapshot.docs;
    } catch (e) {
      debugPrint("Error fetching stock suggestions: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<DocumentSnapshot>(
      suggestionsCallback: _fetchStockSuggestions,
      itemBuilder: (context, DocumentSnapshot suggestion) {
        return ListTile(
          title: Text(suggestion["itemname"]),
          subtitle: Text("Quantity: ${suggestion["quantity"]}"),
        );
      },
      onSelected: (DocumentSnapshot suggestion) {
        String itemId = suggestion.id;
        int quantity = suggestion["quantity"];

        setState(() {
          searchController.clear();
          selectedStocks[itemId] = quantity;
        });

        widget.focusNode.unfocus(); // Close keyboard after selection
      },
    );
  }
}
