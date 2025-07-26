import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chores_provider.dart';
import '../widgets/neumorphic_button.dart';

class ChoresScreen extends StatefulWidget {
  const ChoresScreen({super.key});

  @override
  State<ChoresScreen> createState() => _ChoresScreenState();
}

class _ChoresScreenState extends State<ChoresScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showAddChoreDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Add New Chore',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _titleController.clear();
              _descriptionController.clear();
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                Provider.of<ChoresProvider>(context, listen: false).addChore(
                  _titleController.text,
                  _descriptionController.text,
                );
                Navigator.of(context).pop();
                _titleController.clear();
                _descriptionController.clear();
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'House Chores',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  NeumorphicButton(
                    onPressed: _showAddChoreDialog,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Chores list
              Expanded(
                child: Consumer<ChoresProvider>(
                  builder: (context, choresProvider, child) {
                    if (choresProvider.chores.isEmpty) {
                      return const Center(
                        child: Text(
                          'No chores yet.\nTap + to add a new chore!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: choresProvider.chores.length,
                      itemBuilder: (context, index) {
                        final chore = choresProvider.chores[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            leading: GestureDetector(
                              onTap: () => choresProvider.toggleChore(chore.id),
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: chore.isCompleted
                                      ? const Color(0xFF4CAF50)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: chore.isCompleted
                                        ? const Color(0xFF4CAF50)
                                        : Colors.white70,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: chore.isCompleted
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : null,
                              ),
                            ),
                            title: Text(
                              chore.title,
                              style: TextStyle(
                                color: Colors.white,
                                decoration: chore.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: Colors.white70,
                              ),
                            ),
                            subtitle: chore.description.isNotEmpty
                                ? Text(
                                    chore.description,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      decoration: chore.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      decorationColor: Colors.white70,
                                    ),
                                  )
                                : null,
                            trailing: IconButton(
                              onPressed: () => choresProvider.removeChore(chore.id),
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 