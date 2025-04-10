import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class StockSearchBar extends StatefulWidget {
  final String siteId;
  final FocusNode focusNode;
  final Function({
  required String sid,
  required String skid,
  required String itemname,
  required String suppliername,
  required String itembrand,
  required double quantity,
  required String unit,
  required double rate,
  }) onStockSelected; // Add callback function

  const StockSearchBar({
    super.key,
    required this.siteId,
    required this.focusNode,
    required this.onStockSelected,
  });

  @override
  StockSearchBarState createState() => StockSearchBarState();
}

class StockSearchBarState extends State<StockSearchBar> {
  final TextEditingController searchController = TextEditingController();
  final Map<String, num> selectedStocks = {};

  Future<List<DocumentSnapshot>> _fetchStockSuggestions(String query) async {
    if (query.isEmpty) return [];

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("sites")
          .doc(widget.siteId)
          .collection("stocks")
          .where("itemname", isGreaterThanOrEqualTo: query.toLowerCase())
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


    // builder: TextFieldBuilder(
    //     controller: searchController,
    //     decoration: const InputDecoration(
    //       hintText: 'Search stocks...',
    //       border: OutlineInputBorder(),
    //       prefixIcon: Icon(Icons.search),
    //     ),
    //     focusNode: widget.focusNode,
    //   ),
      suggestionsCallback: _fetchStockSuggestions,
      itemBuilder: (context, DocumentSnapshot suggestion) {
        return ListTile(
          title: Text(suggestion["itemname"]),
          subtitle: Text("Quantity: ${suggestion["quantity"]}"),
        );
      },
      onSelected: (DocumentSnapshot suggestion) {  // Changed from onSelected to onSuggestionSelected
        String itemId = suggestion.id;
        double quantity = (suggestion["quantity"] is int)
            ? (suggestion["quantity"] as int).toDouble()
            : suggestion["quantity"] as double;

        // Call the callback function with all required stock details
        widget.onStockSelected(
          sid: widget.siteId,
          skid: itemId,
          itemname: suggestion["itemname"],
          suppliername: suggestion["suppliername"],
          itembrand: suggestion["brandname"],
          quantity: quantity,
          unit: suggestion["unit"],
          rate: suggestion["rate"] is int
              ? (suggestion["rate"] as int).toDouble()
              : suggestion["rate"] as double,
        );

        setState(() {
          searchController.clear();
          selectedStocks[itemId] = quantity;
        });

        widget.focusNode.unfocus(); // Close keyboard after selection
      },
    );
  }
}