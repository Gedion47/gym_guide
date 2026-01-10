import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/progress_card.dart';
import '../services/data_service.dart';
import '../services/progress_tracker.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  bool _fullBodySelected = false;
  bool _chestSelected = false;
  Map<String, Map<String, int>> _progressData = {};
  List<DateTime> _completedDates = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isLoading = true;
  late ProgressTracker _progressTracker;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _progressTracker = ProgressTracker();
    _loadData();

    // Listen for progress updates
    _progressTracker.addListener(_updateProgress);
  }

  void _updateProgress() {
    if (!mounted) return;

    setState(() {
      // Update from tracker
      if (_fullBodySelected) {
        final currentProgress = _progressTracker.getProgress('full_body');
        _progressData['full_body'] = {
          'completed': currentProgress,
          'target': 3,
        };
      }

      if (_chestSelected) {
        final currentProgress = _progressTracker.getProgress('chest');
        _progressData['chest'] = {
          'completed': currentProgress,
          'target': 4,
        };
      }

      // Save to storage
      _saveProgressToStorage();

      // Check if all workouts are completed for today
      _checkAndMarkDateCompletion();
    });
  }

  Future<void> _loadData() async {
    final fullBodySelected = await DataService.loadWorkoutSelection(DataService.fullBodyKey);
    final chestSelected = await DataService.loadWorkoutSelection(DataService.chestKey);

    final fullBodyProgress = await DataService.loadWorkoutProgress(DataService.fullBodyProgressKey);
    final chestProgress = await DataService.loadWorkoutProgress(DataService.chestProgressKey);

    final completedDates = await DataService.loadCompletedDates();

    if (mounted) {
      setState(() {
        _fullBodySelected = fullBodySelected;
        _chestSelected = chestSelected;

        if (_fullBodySelected) {
          _progressData['full_body'] = fullBodyProgress;
          // Sync tracker with storage
          _progressTracker.setProgress('full_body', fullBodyProgress['completed'] ?? 0);
        }
        if (_chestSelected) {
          _progressData['chest'] = chestProgress;
          // Sync tracker with storage
          _progressTracker.setProgress('chest', chestProgress['completed'] ?? 0);
        }

        _completedDates = completedDates;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProgressToStorage() async {
    if (_fullBodySelected && _progressData.containsKey('full_body')) {
      await DataService.saveWorkoutProgress(
        DataService.fullBodyProgressKey,
        _progressData['full_body']!,
      );
    }

    if (_chestSelected && _progressData.containsKey('chest')) {
      await DataService.saveWorkoutProgress(
        DataService.chestProgressKey,
        _progressData['chest']!,
      );
    }
  }

  bool _isDayCompleted(DateTime day) {
    return _completedDates.any((date) => date.year == day.year && date.month == day.month && date.day == day.day);
  }

  void _showAddWorkoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Workout Progress"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (!_fullBodySelected)
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage('assets/images/full_body.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text("Full Body Workout"),
                    subtitle: Text("3 exercises"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _addFullBodyWorkout();
                    },
                  ),
                if (!_chestSelected)
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage('assets/images/chest.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text("Chest Workout"),
                    subtitle: Text("4 exercises"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _addChestWorkout();
                    },
                  ),
                if (_fullBodySelected && _chestSelected)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "All workouts have been added",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addFullBodyWorkout() async {
    setState(() {
      _fullBodySelected = true;
      _progressData['full_body'] = {
        'completed': 0,
        'target': 3,
      };
    });

    // Reset tracker
    _progressTracker.setProgress('full_body', 0);

    await DataService.saveWorkoutSelection(DataService.fullBodyKey, true);
    await _saveProgressToStorage();
  }

  Future<void> _addChestWorkout() async {
    setState(() {
      _chestSelected = true;
      _progressData['chest'] = {
        'completed': 0,
        'target': 4,
      };
    });

    // Reset tracker
    _progressTracker.setProgress('chest', 0);

    await DataService.saveWorkoutSelection(DataService.chestKey, true);
    await _saveProgressToStorage();
  }

  Future<void> _removeFullBody() async {
    setState(() {
      _fullBodySelected = false;
      _progressData.remove('full_body');
    });

    // Reset tracker
    _progressTracker.setProgress('full_body', 0);

    await DataService.saveWorkoutSelection(DataService.fullBodyKey, false);
  }

  Future<void> _removeChest() async {
    setState(() {
      _chestSelected = false;
      _progressData.remove('chest');
    });

    // Reset tracker
    _progressTracker.setProgress('chest', 0);

    await DataService.saveWorkoutSelection(DataService.chestKey, false);
  }

  Future<void> _checkAndMarkDateCompletion() async {
    if (!_fullBodySelected && !_chestSelected) return;

    bool allCompleted = true;

    if (_fullBodySelected) {
      final fullBodyData = _progressData['full_body'];
      if (fullBodyData == null || fullBodyData['completed']! < fullBodyData['target']!) {
        allCompleted = false;
      }
    }

    if (_chestSelected) {
      final chestData = _progressData['chest'];
      if (chestData == null || chestData['completed']! < chestData['target']!) {
        allCompleted = false;
      }
    }

    if (allCompleted) {
      final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      if (!_completedDates.any((date) => date.year == today.year && date.month == today.month && date.day == today.day)) {
        _completedDates.add(today);
        await DataService.saveCompletedDates(_completedDates);
        setState(() {}); // Trigger UI update for calendar
      }
    }
  }

  @override
  void dispose() {
    _progressTracker.removeListener(_updateProgress);
    super.dispose();
  }

  Widget _buildCalendar() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout Calendar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 10),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },

            // Remove header format button
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: Icon(Icons.chevron_left),
              rightChevronIcon: Icon(Icons.chevron_right),
            ),

            // Calendar styling
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(color: Colors.black),
              outsideDaysVisible: false,
            ),

            // Days of week styling
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
              weekendStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),

            // Custom day styling with green circles
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final isCompleted = _isDayCompleted(day);
                final isToday = isSameDay(day, DateTime.now());

                return Container(
                  margin: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isToday ? Border.all(color: Colors.blue, width: 2) : null,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: isCompleted ? Colors.white : Colors.black,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
              todayBuilder: (context, day, focusedDay) {
                final isCompleted = _isDayCompleted(day);

                return Container(
                  margin: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : Colors.blue.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: isCompleted ? Colors.white : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                final isCompleted = _isDayCompleted(day);

                return Container(
                  margin: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Progress Tracker',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final List<Widget> progressCards = [];

    if (_fullBodySelected) {
      progressCards.add(
        ProgressCard(
          imagePath: "assets/images/full_body.png",
          exType: "Full Body Workout",
          workoutType: "full_body",
          initialData: _progressData['full_body']!,
          onRemove: _removeFullBody,
        ),
      );
    }

    if (_chestSelected) {
      progressCards.add(
        ProgressCard(
          imagePath: "assets/images/chest.png",
          exType: "Chest Workout",
          workoutType: "chest",
          initialData: _progressData['chest']!,
          onRemove: _removeChest,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Progress Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Blue Add Button (same as diet page)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _showAddWorkoutDialog,
              icon: Icon(Icons.add),
              label: Text('Add Workout Progress'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // Content Area
          if (progressCards.isNotEmpty)
            Expanded(
              child: ListView(
                children: [
                  ...progressCards,
                  _buildCalendar(),
                ],
              ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "No Workout Progress Added",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Tap 'Add Workout Progress' to track your workouts",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
