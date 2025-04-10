import 'package:flutter/material.dart';

class EstimationPage extends StatefulWidget {
  const EstimationPage({super.key});

  @override
  EstimationPageState createState() => EstimationPageState();
}

class EstimationPageState extends State<EstimationPage> {
  List<Map<String, dynamic>> expenses = [];
  TextEditingController itemController = TextEditingController();
  TextEditingController costController = TextEditingController();

  void addExpense() {
    String item = itemController.text;
    double? cost = double.tryParse(costController.text);

    if (item.isNotEmpty && cost != null) {
      setState(() {
        expenses.add({'item': item, 'cost': cost});
        itemController.clear();
        costController.clear();
      });
    }
  }

  double getTotalCost() {
    return expenses.fold(0.0, (sum, expense) => sum + expense['cost']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Estimation Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: itemController,
              decoration: InputDecoration(labelText: 'Expense Item'),
            ),
            TextField(
              controller: costController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Cost (NPR)'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addExpense,
              child: Text('Add Expense'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(expenses[index]['item']),
                    trailing: Text(
                        'NPR ${expenses[index]['cost'].toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            Divider(),
            Text(
              'Total Cost: NPR ${getTotalCost().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EstimationPage(),
  ));
}
