import 'package:flutter/material.dart';
import 'data_service.dart';

class ProgressTracker extends ChangeNotifier {
  // Singleton instance
  static final ProgressTracker _instance = ProgressTracker._internal();
  factory ProgressTracker() => _instance;
  ProgressTracker._internal();

  // In-memory cache for progress
  final Map<String, int> _progressCache = {};

  /// Increment progress for a workout type
  Future<void> incrementProgress(String workoutType) async {
    final progress = await DataService.loadWorkoutProgress(workoutType == 'full_body' ? DataService.fullBodyProgressKey : DataService.chestProgressKey);
    final target = progress['target'] ?? (workoutType == 'full_body' ? 3 : 4);
    final newCompleted = (progress['completed'] ?? 0) + 1;

    // Save updated progress
    final updatedProgress = {
      'completed': newCompleted > target ? target : newCompleted,
      'target': target,
    };

    await DataService.saveWorkoutProgress(workoutType == 'full_body' ? DataService.fullBodyProgressKey : DataService.chestProgressKey, updatedProgress);

    // Update cache
    _progressCache[workoutType] = updatedProgress['completed']!;

    // Auto-mark calendar if full target reached
    if (newCompleted >= target) {
      final completedDates = await DataService.loadCompletedDates();
      final today = DateTime.now();
      if (!completedDates.any((d) => isSameDate(d, today))) {
        completedDates.add(today);
        await DataService.saveCompletedDates(completedDates);
      }
    }

    notifyListeners();
  }

  /// Set progress for a workout type
  void setProgress(String workoutType, int completed) {
    _progressCache[workoutType] = completed;
    notifyListeners();
  }

  /// Get progress for a workout type
  int getProgress(String workoutType) {
    return _progressCache[workoutType] ?? 0;
  }

  /// Reset all progress
  Future<void> resetAll() async {
    _progressCache.clear();
    notifyListeners();
  }

  /// Load current progress
  Future<Map<String, int>> getProgressData(String workoutType) async {
    return await DataService.loadWorkoutProgress(workoutType == 'full_body' ? DataService.fullBodyProgressKey : DataService.chestProgressKey);
  }

  /// Check if two dates are the same (ignoring time)
  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Reset daily progress at midnight
  Future<void> resetProgressIfNeeded() async {
    final lastActive = await DataService.loadLastActiveDate();
    final now = DateTime.now();

    if (lastActive == null || !isSameDate(lastActive, now)) {
      // Reset progress for all workouts
      final fullBodyProgress = await DataService.loadWorkoutProgress(DataService.fullBodyProgressKey);
      final chestProgress = await DataService.loadWorkoutProgress(DataService.chestProgressKey);

      await DataService.saveWorkoutProgress(DataService.fullBodyProgressKey, {
        'completed': 0,
        'target': fullBodyProgress['target'] ?? 3
      });
      await DataService.saveWorkoutProgress(DataService.chestProgressKey, {
        'completed': 0,
        'target': chestProgress['target'] ?? 4
      });

      // Save today as last active date
      await DataService.saveLastActiveDate(now);

      notifyListeners();
    }
  }
}
