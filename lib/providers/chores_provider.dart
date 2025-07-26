import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Chore {
  final String id;
  final String title;
  final String description;
  bool isCompleted;
  final DateTime createdAt;

  Chore({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Chore.fromJson(Map<String, dynamic> json) {
    return Chore(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ChoresProvider with ChangeNotifier {
  List<Chore> _chores = [];

  List<Chore> get chores => _chores;
  List<Chore> get completedChores => _chores.where((chore) => chore.isCompleted).toList();
  List<Chore> get pendingChores => _chores.where((chore) => !chore.isCompleted).toList();

  ChoresProvider() {
    _loadChores();
  }

  void addChore(String title, String description) {
    final chore = Chore(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    _chores.add(chore);
    _saveChores();
    notifyListeners();
  }

  void toggleChore(String id) {
    final choreIndex = _chores.indexWhere((chore) => chore.id == id);
    if (choreIndex != -1) {
      _chores[choreIndex].isCompleted = !_chores[choreIndex].isCompleted;
      _saveChores();
      notifyListeners();
    }
  }

  void removeChore(String id) {
    _chores.removeWhere((chore) => chore.id == id);
    _saveChores();
    notifyListeners();
  }

  Future<void> _loadChores() async {
    final prefs = await SharedPreferences.getInstance();
    final choresJson = prefs.getStringList('chores') ?? [];
    _chores = choresJson
        .map((choreJson) => Chore.fromJson(json.decode(choreJson)))
        .toList();
    notifyListeners();
  }

  Future<void> _saveChores() async {
    final prefs = await SharedPreferences.getInstance();
    final choresJson = _chores
        .map((chore) => json.encode(chore.toJson()))
        .toList();
    await prefs.setStringList('chores', choresJson);
  }
} 