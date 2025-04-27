import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:construction/presentation/includes/appbar.dart';
import 'package:construction/utils/app_colors.dart';
import 'package:logger/logger.dart';

import '../../../main.dart';

class EstimationPage extends StatefulWidget {
  const EstimationPage({super.key});

  @override
  State<EstimationPage> createState() => _EstimationPageState();
}

class _EstimationPageState extends State<EstimationPage> {
  final _materialFormKey = GlobalKey<FormState>(); // Form key for materials
  final _laborFormKey = GlobalKey<FormState>();   // Form key for labor
  final _materialNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitCostController = TextEditingController();
  final _laborTaskController = TextEditingController();
  final _laborHoursController = TextEditingController();
  final _laborRateController = TextEditingController();
  List<Map<String, dynamic>> materials = [];
  List<Map<String, dynamic>> laborTasks = [];
  double? _cachedTotalCost;
  final _logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic> && args.containsKey('sid') && args['sid'] != null) {
      context.read<EstimationBloc>().add(FetchEstimationEvent(sid: args['sid']));
    } else {
      _logger.e('Invalid navigation arguments: $args');
    }
  }

  @override
  void dispose() {
    _materialNameController.dispose();
    _quantityController.dispose();
    _unitCostController.dispose();
    _laborTaskController.dispose();
    _laborHoursController.dispose();
    _laborRateController.dispose();
    super.dispose();
  }

  void _addMaterial() {
    if (!_materialFormKey.currentState!.validate()) {
      BotToast.showText(
        text: "Please correct the material input fields",
        contentColor: AppColors.red,
      );
      return;
    }

    final quantity = double.tryParse(_quantityController.text);
    final unitCost = double.tryParse(_unitCostController.text);

    if (quantity == null || unitCost == null || quantity <= 0 || unitCost <= 0) {
      BotToast.showText(
        text: "Enter valid positive numbers for quantity and unit cost",
        contentColor: AppColors.red,
      );
      return;
    }

    final totalCost = quantity * unitCost;

    setState(() {
      materials.add({
        'name': _materialNameController.text,
        'quantity': quantity,
        'unitCost': unitCost,
        'totalCost': totalCost,
      });
      _cachedTotalCost = null;
      _materialNameController.clear();
      _quantityController.clear();
      _unitCostController.clear();
    });
  }

  void _editMaterial(int index) {
    final material = materials[index];
    _materialNameController.text = material['name'] ?? '';
    _quantityController.text = material['quantity']?.toString() ?? '';
    _unitCostController.text = material['unitCost']?.toString() ?? '';

    setState(() {
      materials.removeAt(index);
      _cachedTotalCost = null;
    });
  }

  void _addLaborTask() {
    if (!_laborFormKey.currentState!.validate()) {
      BotToast.showText(
        text: "Please correct the labor task input fields",
        contentColor: AppColors.red,
      );
      return;
    }

    final hours = double.tryParse(_laborHoursController.text);
    final rate = double.tryParse(_laborRateController.text);

    if (hours == null || rate == null || hours <= 0 || rate <= 0) {
      BotToast.showText(
        text: "Enter valid positive numbers for hours and rate",
        contentColor: AppColors.red,
      );
      return;
    }

    final totalCost = hours * rate;

    setState(() {
      laborTasks.add({
        'task': _laborTaskController.text,
        'hours': hours,
        'rate': rate,
        'totalCost': totalCost,
      });
      _cachedTotalCost = null;
      _laborTaskController.clear();
      _laborHoursController.clear();
      _laborRateController.clear();
    });
  }

  void _editLaborTask(int index) {
    final task = laborTasks[index];
    _laborTaskController.text = task['task'] ?? '';
    _laborHoursController.text = task['hours']?.toString() ?? '';
    _laborRateController.text = task['rate']?.toString() ?? '';

    setState(() {
      laborTasks.removeAt(index);
      _cachedTotalCost = null;
    });
  }

  double _calculateTotalCost() {
    if (_cachedTotalCost != null) return _cachedTotalCost!;
    final materialCost = materials.fold<double>(
      0,
          (sum, item) => sum + (item['totalCost'] as double? ?? 0),
    );
    final laborCost = laborTasks.fold<double>(
      0,
          (sum, item) => sum + (item['totalCost'] as double? ?? 0),
    );
    _cachedTotalCost = materialCost + laborCost;
    return _cachedTotalCost!;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null || !args.containsKey('sid') || args['sid'] == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Error: Invalid site ID",
            style: TextStyle(color: AppColors.red, fontSize: size.width * 0.04),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(size.width, size.height * 0.09),
        child: CustomAppbar(
          title: "${args['title'] ?? 'Site'} Estimation",
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ).customAppBar(),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.02,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.blue.withOpacity(0.1), Colors.white],
          ),
        ),
        child: BlocConsumer<EstimationBloc, EstimationState>(
          listener: (context, state) {
            if (state is EstimationLoading) {
              BotToast.closeAllLoading();
              BotToast.showCustomLoading(
                toastBuilder: (_) => customLoading(size),
              );
            } else if (state is EstimationLoaded) {
              BotToast.closeAllLoading();
              setState(() {
                materials = List<Map<String, dynamic>>.from(
                  state.estimation['materials'] ?? [],
                );
                laborTasks = List<Map<String, dynamic>>.from(
                  state.estimation['laborTasks'] ?? [],
                );
                _cachedTotalCost = null;
              });
            } else if (state is EstimationFailure) {
              BotToast.closeAllLoading();
              BotToast.showText(
                text: "Error: ${state.error}",
                contentColor: AppColors.red,
                duration: const Duration(seconds: 5),
              );
            } else if (state is EstimationSuccess) {
              BotToast.closeAllLoading();
              BotToast.showText(
                text: "Estimation Saved Successfully",
                contentColor: AppColors.green,
              );
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return ListView(
              children: [
                Form(
                  key: _materialFormKey, // Separate form for materials
                  child: MaterialInputSection(
                    size: size,
                    nameController: _materialNameController,
                    quantityController: _quantityController,
                    unitCostController: _unitCostController,
                    onAdd: _addMaterial,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                MaterialListSection(
                  size: size,
                  materials: materials,
                  onDelete: (index) => setState(() {
                    materials.removeAt(index);
                    _cachedTotalCost = null;
                  }),
                  onEdit: _editMaterial,
                ),
                SizedBox(height: size.height * 0.02),
                Form(
                  key: _laborFormKey, // Separate form for labor
                  child: LaborInputSection(
                    size: size,
                    taskController: _laborTaskController,
                    hoursController: _laborHoursController,
                    rateController: _laborRateController,
                    onAdd: _addLaborTask,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                LaborListSection(
                  size: size,
                  laborTasks: laborTasks,
                  onDelete: (index) => setState(() {
                    laborTasks.removeAt(index);
                    _cachedTotalCost = null;
                  }),
                  onEdit: _editLaborTask,
                ),
                SizedBox(height: size.height * 0.02),
                SummarySection(
                  size: size,
                  materials: materials,
                  laborTasks: laborTasks,
                  totalCost: _calculateTotalCost(),
                ),
                SizedBox(height: size.height * 0.02),
                SaveButton(
                  size: size,
                  materialFormKey: _materialFormKey, // Pass material form key
                  laborFormKey: _laborFormKey,       // Pass labor form key
                  materials: materials,
                  laborTasks: laborTasks,
                  sid: args['sid'],
                  totalCost: _calculateTotalCost(),
                  materialControllers: [
                    _materialNameController,
                    _quantityController,
                    _unitCostController,
                  ],
                  laborControllers: [
                    _laborTaskController,
                    _laborHoursController,
                    _laborRateController,
                  ],
                ),
                if (state is EstimationFailure)
                  RetryButton(
                    onRetry: () => context.read<EstimationBloc>().add(
                      FetchEstimationEvent(sid: args['sid']),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MaterialInputSection extends StatelessWidget {
  final Size size;
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController unitCostController;
  final VoidCallback onAdd;

  const MaterialInputSection({
    super.key,
    required this.size,
    required this.nameController,
    required this.quantityController,
    required this.unitCostController,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Material",
            style: TextStyle(
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Material Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) =>
            value?.isEmpty ?? true ? "Enter material name" : null,
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: "Quantity",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return "Enter quantity";
                    final num = double.tryParse(value!);
                    if (num == null || num <= 0) return "Enter valid positive number";
                    return null;
                  },
                ),
              ),
              SizedBox(width: size.width * 0.02),
              Expanded(
                child: TextFormField(
                  controller: unitCostController,
                  decoration: InputDecoration(
                    labelText: "Unit Cost",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return "Enter unit cost";
                    final num = double.tryParse(value!);
                    if (num == null || num <= 0) return "Enter valid positive number";
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: onAdd,
              icon: Icon(Icons.add, size: size.width * 0.045),
              label: const Text("Add"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MaterialListSection extends StatelessWidget {
  final Size size;
  final List<Map<String, dynamic>> materials;
  final Function(int) onDelete;
  final Function(int) onEdit;

  const MaterialListSection({
    super.key,
    required this.size,
    required this.materials,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (materials.isEmpty) {
      return Container(
        padding: EdgeInsets.all(size.width * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            "No materials added",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: size.width * 0.035,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Materials List",
            style: TextStyle(
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final material = materials[index];
              return ListTile(
                title: Text(material['name'] ?? 'Unknown'),
                subtitle: Text(
                  "Qty: ${material['quantity']?.toString() ?? '0'} | "
                      "Unit Cost: NRS. ${material['unitCost']?.toStringAsFixed(2) ?? '0.00'} | "
                      "Total: NRS. ${material['totalCost']?.toStringAsFixed(2) ?? '0.00'}",
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // IconButton(
                    //   icon: Icon(Icons.edit, color: AppColors.blue),
                    //   onPressed: () => onEdit(index),
                    // ),
                    IconButton(
                      icon: Icon(Icons.delete, color: AppColors.red),
                      onPressed: () => onDelete(index),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class LaborInputSection extends StatelessWidget {
  final Size size;
  final TextEditingController taskController;
  final TextEditingController hoursController;
  final TextEditingController rateController;
  final VoidCallback onAdd;

  const LaborInputSection({
    super.key,
    required this.size,
    required this.taskController,
    required this.hoursController,
    required this.rateController,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Labor Task",
            style: TextStyle(
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          TextFormField(
            controller: taskController,
            decoration: InputDecoration(
              labelText: "Task Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) =>
            value?.isEmpty ?? true ? "Enter task name" : null,
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: hoursController,
                  decoration: InputDecoration(
                    labelText: "Hours",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return "Enter hours";
                    final num = double.tryParse(value!);
                    if (num == null || num <= 0) return "Enter valid positive number";
                    return null;
                  },
                ),
              ),
              SizedBox(width: size.width * 0.02),
              Expanded(
                child: TextFormField(
                  controller: rateController,
                  decoration: InputDecoration(
                    labelText: "Hourly Rate",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return "Enter hourly rate";
                    final num = double.tryParse(value!);
                    if (num == null || num <= 0) return "Enter valid positive number";
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: onAdd,
              icon: Icon(Icons.add, size: size.width * 0.045),
              label: const Text("Add"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LaborListSection extends StatelessWidget {
  final Size size;
  final List<Map<String, dynamic>> laborTasks;
  final Function(int) onDelete;
  final Function(int) onEdit;

  const LaborListSection({
    super.key,
    required this.size,
    required this.laborTasks,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (laborTasks.isEmpty) {
      return Container(
        padding: EdgeInsets.all(size.width * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            "No labor tasks added",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: size.width * 0.035,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Labor Tasks List",
            style: TextStyle(
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: laborTasks.length,
            itemBuilder: (context, index) {
              final task = laborTasks[index];
              return ListTile(
                title: Text(task['task'] ?? 'Unknown'),
                subtitle: Text(
                  "Hours: ${task['hours']?.toString() ?? '0'} | "
                      "Rate: NRS. ${task['rate']?.toStringAsFixed(2) ?? '0.00'} | "
                      "Total: NRS. ${task['totalCost']?.toStringAsFixed(2) ?? '0.00'}",
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // IconButton(
                    //   icon: Icon(Icons.edit, color: AppColors.blue),
                    //   onPressed: () => onEdit(index),
                    // ),
                    IconButton(
                      icon: Icon(Icons.delete, color: AppColors.red),
                      onPressed: () => onDelete(index),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SummarySection extends StatelessWidget {
  final Size size;
  final List<Map<String, dynamic>> materials;
  final List<Map<String, dynamic>> laborTasks;
  final double totalCost;

  const SummarySection({
    super.key,
    required this.size,
    required this.materials,
    required this.laborTasks,
    required this.totalCost,
  });

  @override
  Widget build(BuildContext context) {
    final materialCost = materials.fold<double>(
      0,
          (sum, item) => sum + (item['totalCost'] as double? ?? 0),
    );
    final laborCost = laborTasks.fold<double>(
      0,
          (sum, item) => sum + (item['totalCost'] as double? ?? 0),
    );

    return Container(
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cost Summary",
            style: TextStyle(
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            "Materials Cost: NRS. ${materialCost.toStringAsFixed(2)}",
            style: TextStyle(fontSize: size.width * 0.035),
          ),
          Text(
            "Labor Cost: NRS. ${laborCost.toStringAsFixed(2)}",
            style: TextStyle(fontSize: size.width * 0.035),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            "Total Cost: NRS. ${totalCost.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.bold,
              color: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  final Size size;
  final GlobalKey<FormState> materialFormKey; // Material form key
  final GlobalKey<FormState> laborFormKey;   // Labor form key
  final List<Map<String, dynamic>> materials;
  final List<Map<String, dynamic>> laborTasks;
  final String sid;
  final double totalCost;
  final List<TextEditingController> materialControllers;
  final List<TextEditingController> laborControllers;

  const SaveButton({
    super.key,
    required this.size,
    required this.materialFormKey,
    required this.laborFormKey,
    required this.materials,
    required this.laborTasks,
    required this.sid,
    required this.totalCost,
    required this.materialControllers,
    required this.laborControllers,
  });

  @override
  Widget build(BuildContext context) {
    // Access navigation arguments to get the role
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print('this is the args');
    print(args);

    return ElevatedButton(
      onPressed: () {
        // Check if the user is a supervisor
        if (args == null || args['role'] != 'Supervisor') {
          BotToast.showText(
            text: "Only supervisors can save estimations",
            contentColor: AppColors.red,
            duration:  const Duration(seconds: 3),
          );
          return;
        }

        final isAddingMaterial = materialControllers.any((controller) => controller.text.isNotEmpty);
        final isAddingLabor = laborControllers.any((controller) => controller.text.isNotEmpty);

        // Validate material form if there are material inputs
        bool isMaterialValid = true;
        if (isAddingMaterial) {
          isMaterialValid = materialFormKey.currentState!.validate();
        }

        // Validate labor form if there are labor inputs
        bool isLaborValid = true;
        if (isAddingLabor) {
          isLaborValid = laborFormKey.currentState!.validate();
        }

        // Show error if any form is invalid
        if ((isAddingMaterial && !isMaterialValid) || (isAddingLabor && !isLaborValid)) {
          BotToast.showText(
            text: "Please correct the input fields",
            contentColor: AppColors.red,
          );
          return;
        }

        // Ensure at least one material or labor task is added
        if (materials.isEmpty && laborTasks.isEmpty) {
          BotToast.showText(
            text: "Add at least one material or labor task",
            contentColor: AppColors.red,
          );
          return;
        }

        context.read<EstimationBloc>().add(
          SaveEstimationEvent(
            sid: sid,
            materials: materials,
            laborTasks: laborTasks,
            totalCost: totalCost,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
      ),
      child: Text(
        "Save Estimation",
        style: TextStyle(
          fontSize: size.width * 0.04,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class RetryButton extends StatelessWidget {
  final VoidCallback onRetry;

  const RetryButton({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
      child: ElevatedButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
        label: const Text("Retry"),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class EstimationBloc extends Bloc<EstimationEvent, EstimationState> {
  final Logger _logger = Logger();

  EstimationBloc() : super(EstimationInitial()) {
    on<FetchEstimationEvent>(_onFetchEstimation);
    on<SaveEstimationEvent>(_onSaveEstimation);
  }

  Future<void> _onFetchEstimation(FetchEstimationEvent event, Emitter<EstimationState> emit) async {
    emit(EstimationLoading());
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('sites')
          .doc(event.sid)
          .collection('estimations')
          .doc('estimation')
          .get();

      emit(EstimationLoaded(estimation: docSnapshot.data() ?? {}));
    } on FirebaseException catch (e) {
      _logger.e('Firestore error fetching estimation: ${e.code}', error: e);
      emit(EstimationFailure(error: 'Failed to fetch estimation: ${e.message}'));
    } catch (e) {
      _logger.e('Unexpected error fetching estimation', error: e);
      emit(EstimationFailure(error: 'Unexpected error: $e'));
    }
  }

  Future<void> _onSaveEstimation(SaveEstimationEvent event, Emitter<EstimationState> emit) async {
    emit(EstimationLoading());
    try {
      final siteDoc = await FirebaseFirestore.instance.collection('sites').doc(event.sid).get();
      if (!siteDoc.exists) {
        _logger.e('Site not found: ${event.sid}');
        emit(EstimationFailure(error: "Site with ID ${event.sid} does not exist"));
        return;
      }

      await FirebaseFirestore.instance
          .collection('sites')
          .doc(event.sid)
          .collection('estimations')
          .doc('estimation')
          .set({
        'materials': event.materials,
        'laborTasks': event.laborTasks,
        'totalCost': event.totalCost,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      emit(EstimationSuccess());
    } on FirebaseException catch (e) {
      _logger.e('Firestore error saving estimation: ${e.code}', error: e);
      emit(EstimationFailure(error: 'Failed to save estimation: ${e.message}'));
    } catch (e) {
      _logger.e('Unexpected error saving estimation', error: e);
      emit(EstimationFailure(error: 'Unexpected error: $e'));
    }
  }
}

abstract class EstimationEvent {}

class FetchEstimationEvent extends EstimationEvent {
  final String sid;

  FetchEstimationEvent({required this.sid});
}

class SaveEstimationEvent extends EstimationEvent {
  final String sid;
  final List<Map<String, dynamic>> materials;
  final List<Map<String, dynamic>> laborTasks;
  final double totalCost;

  SaveEstimationEvent({
    required this.sid,
    required this.materials,
    required this.laborTasks,
    required this.totalCost,
  });
}

abstract class EstimationState {}

class EstimationInitial extends EstimationState {}

class EstimationLoading extends EstimationState {}

class EstimationSuccess extends EstimationState {}

class EstimationFailure extends EstimationState {
  final String error;
  EstimationFailure({required this.error});
}

class EstimationLoaded extends EstimationState {
  final Map<String, dynamic> estimation;

  EstimationLoaded({required this.estimation});
}
