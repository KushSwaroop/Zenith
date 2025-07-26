import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerProvider with ChangeNotifier {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  int _totalFocusTime = 0;
  
  // Tree growth stages (in seconds)
  static const int saplingStage = 0;
  static const int smallTreeStage = 1800; // 30 minutes
  static const int mediumTreeStage = 3600; // 1 hour
  static const int fullTreeStage = 7200; // 2 hours

  int get elapsedSeconds => _elapsedSeconds;
  bool get isRunning => _isRunning;
  int get totalFocusTime => _totalFocusTime;
  
  String get formattedTime {
    int minutes = _elapsedSeconds ~/ 60;
    int seconds = _elapsedSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  int get treeGrowthStage {
    if (_elapsedSeconds >= fullTreeStage) return 4; // Full tree
    if (_elapsedSeconds >= mediumTreeStage) return 3; // Medium tree
    if (_elapsedSeconds >= smallTreeStage) return 2; // Small tree
    return 1; // Sapling
  }

  TimerProvider() {
    _loadData();
  }

  void startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _elapsedSeconds++;
        notifyListeners();
      });
      notifyListeners();
    }
  }

  void stopTimer() {
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
      _totalFocusTime += _elapsedSeconds;
      _elapsedSeconds = 0;
      _saveData();
      notifyListeners();
    }
  }

  void resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    _elapsedSeconds = 0;
    notifyListeners();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _totalFocusTime = prefs.getInt('totalFocusTime') ?? 0;
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalFocusTime', _totalFocusTime);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
} 