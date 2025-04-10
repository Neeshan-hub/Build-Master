import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:construction/utils/app_colors.dart';

class SubtasksPage extends StatefulWidget {
  const SubtasksPage({super.key});

  @override
  State<SubtasksPage> createState() => _SubtasksPageState();
}

class _SubtasksPageState extends State<SubtasksPage> {
  final TextEditingController _subtaskController = TextEditingController();

  @override
  void dispose() {
    _subtaskController.dispose();
    super.dispose();
  }

  // Add a new subtask
  void _addSubtask(String sid, String wid) {
    final title = _subtaskController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Subtask title cannot be empty")),
      );
      return;
    }

    FirebaseFirestore.instance
        .collection("sites")
        .doc(sid)
        .collection("works")
        .doc(wid)
        .update({
      "subtasks.$title": false, // New subtasks start as incomplete
    }).then((_) {
      _subtaskController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Subtask '$title' added")),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add subtask: $error")),
      );
    });
  }

  // Delete a subtask
  void _deleteSubtask(String sid, String wid, String title) {
    FirebaseFirestore.instance
        .collection("sites")
        .doc(sid)
        .collection("works")
        .doc(wid)
        .update({
      "subtasks.$title": FieldValue.delete(), // Remove the key from the map
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Subtask '$title' deleted")),
      );
      // Update progress after deletion
      _updateProgress(sid, wid);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete subtask: $error")),
      );
    });
  }

  // Mark subtask complete/incomplete and update progress
  void _toggleSubtask(String sid, String wid, String title, bool currentValue) {
    FirebaseFirestore.instance
        .collection("sites")
        .doc(sid)
        .collection("works")
        .doc(wid)
        .update({
      "subtasks.$title": !currentValue, // Toggle the boolean value
    }).then((_) {
      // Update progress after toggling
      _updateProgress(sid, wid);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update subtask: $error")),
      );
    });
  }

  // Calculate and update progress based on subtasks
  void _updateProgress(String sid, String wid) async {
    try {
      final updatedSubtasks = (await FirebaseFirestore.instance
          .collection("sites")
          .doc(sid)
          .collection("works")
          .doc(wid)
          .get())
          .data()!['subtasks'] as Map<String, dynamic>;
      final completedCount = updatedSubtasks.values.where((v) => v == true).length;
      final totalCount = updatedSubtasks.length;
      final newProgress = totalCount > 0 ? (completedCount / totalCount) * 100 : 0;

      await FirebaseFirestore.instance
          .collection("sites")
          .doc(sid)
          .collection("works")
          .doc(wid)
          .update({"progress": newProgress});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update progress: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text("Subtasks for ${args['title']}"),
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Add subtask input field and button
          Padding(
            padding: EdgeInsets.all(size.width * 0.04),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subtaskController,
                    decoration: InputDecoration(
                      hintText: "Enter new subtask",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                ElevatedButton(
                  onPressed: () => _addSubtask(args['sid'], args['wid']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          // Subtasks list
          Expanded(
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("sites")
                  .doc(args['sid'])
                  .collection("works")
                  .doc(args['wid'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final data = snapshot.data!.data()!;
                final Map<String, dynamic> subtasks = data['subtasks'] ?? {};

                if (subtasks.isEmpty) {
                  return const Center(child: Text("No subtasks available"));
                }

                return Padding(
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: ListView.builder(
                    itemCount: subtasks.length,
                    itemBuilder: (context, index) {
                      final title = subtasks.keys.elementAt(index);
                      final completed = subtasks[title] as bool;
                      return ListTile(
                        title: Text(title),
                        leading: Checkbox(
                          value: completed,
                          onChanged: (bool? value) {
                            _toggleSubtask(args['sid'], args['wid'], title, completed);
                          },
                          activeColor: AppColors.green,
                          checkColor: AppColors.white,
                        ),
                        trailing: IconButton(
                          icon:  Icon(Icons.delete, color: AppColors.red),
                          onPressed: () {
                            _deleteSubtask(args['sid'], args['wid'], title);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}