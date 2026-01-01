import 'package:flutter/material.dart';
import 'dart:async';

class FullBodyWorkoutPage extends StatefulWidget {
  const FullBodyWorkoutPage({super.key});

  @override
  State<FullBodyWorkoutPage> createState() => _FullBodyWorkoutPageState();
}

class _FullBodyWorkoutPageState extends State<FullBodyWorkoutPage> {
  // Timer controllers for each exercise
  late List<Timer?> _timers;
  late List<int> _remainingTimes;
  late List<bool> _isRunning;
  late List<String> _timeTexts;

  // Exercise data
  final List<Map<String, dynamic>> _exercises = [
    {
      'exerciseNumber': 1,
      'exerciseName': 'Push up',
      'rounds': '20 rounds, 30 seconds',
      'initialTime': 30,
      'rating': 7,
    },
    {
      'exerciseNumber': 2,
      'exerciseName': 'Pull up',
      'rounds': '15 rounds, 30 seconds',
      'initialTime': 30,
      'rating': 6,
    },
    {
      'exerciseNumber': 3,
      'exerciseName': 'Lunge',
      'rounds': '10 rounds each leg, 40 seconds',
      'initialTime': 40,
      'rating': 6,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Initialize all timers and states
    _timers = List.generate(_exercises.length, (_) => null);
    _remainingTimes = _exercises.map((e) => e['initialTime'] as int).toList();
    _isRunning = List.generate(_exercises.length, (_) => false);
    _timeTexts = _exercises.map((e) => _formatTime(e['initialTime'] as int)).toList();
  }

  @override
  void dispose() {
    // Cancel all timers when the widget is disposed
    for (var timer in _timers) {
      timer?.cancel();
    }
    super.dispose();
  }

  String _formatTime(int seconds) {
    return '00:${seconds.toString().padLeft(2, '0')}';
  }

  void _startTimer(int index) {
    // If timer is already running, do nothing
    if (_isRunning[index]) return;

    setState(() {
      _isRunning[index] = true;
    });

    _timers[index] = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTimes[index] > 0) {
          _remainingTimes[index]--;
          _timeTexts[index] = _formatTime(_remainingTimes[index]);
        } else {
          // Timer finished
          timer.cancel();
          _timers[index] = null;
          _isRunning[index] = false;

          // Reset to initial time
          _remainingTimes[index] = _exercises[index]['initialTime'] as int;
          _timeTexts[index] = _formatTime(_remainingTimes[index]);

          // Show completion message
          _showExerciseCompleteDialog(_exercises[index]['exerciseName'] as String);
        }
      });
    });
  }

  void _stopTimer(int index) {
    if (_timers[index] != null) {
      _timers[index]!.cancel();
      _timers[index] = null;
    }

    setState(() {
      _isRunning[index] = false;
    });
  }

  void _resetTimer(int index) {
    // Stop timer if running
    if (_timers[index] != null) {
      _timers[index]!.cancel();
      _timers[index] = null;
    }

    setState(() {
      _isRunning[index] = false;
      _remainingTimes[index] = _exercises[index]['initialTime'] as int;
      _timeTexts[index] = _formatTime(_remainingTimes[index]);
    });
  }

  void _showExerciseCompleteDialog(String exerciseName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exercise Complete!'),
        content: Text('Great job! You finished $exerciseName.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  double _getProgressValue() {
    int completedExercises = 0;
    for (int i = 0; i < _exercises.length; i++) {
      if (_remainingTimes[i] == 0) {
        completedExercises++;
      }
    }
    return completedExercises / _exercises.length;
  }

  int _getCompletedCount() {
    int count = 0;
    for (int i = 0; i < _exercises.length; i++) {
      if (_remainingTimes[i] == 0) {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage('assets/images/full_body.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              'Full Body Workout',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Workout progress header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_exercises.length} exercises',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: _getProgressValue(),
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${_getCompletedCount()}/${_exercises.length}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: Colors.grey[300]),

            // Exercise list
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  // Generate exercise cards dynamically
                  for (int i = 0; i < _exercises.length; i++) ...[
                    if (i > 0) SizedBox(height: 20),
                    _buildExerciseCard(
                      index: i,
                      exerciseNumber: _exercises[i]['exerciseNumber'] as int,
                      exerciseName: _exercises[i]['exerciseName'] as String,
                      rounds: _exercises[i]['rounds'] as String,
                      time: _timeTexts[i],
                      rating: _exercises[i]['rating'] as int,
                      isRunning: _isRunning[i],
                      isCompleted: _remainingTimes[i] == 0,
                    ),
                  ],
                ],
              ),
            ),

            // Start All button at bottom
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Start all timers
                        for (int i = 0; i < _exercises.length; i++) {
                          if (!_isRunning[i] && _remainingTimes[i] > 0) {
                            _startTimer(i);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Start All',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Reset all timers
                      for (int i = 0; i < _exercises.length; i++) {
                        _resetTimer(i);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      minimumSize: Size(60, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Icon(Icons.replay),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard({
    required int index,
    required int exerciseNumber,
    required String exerciseName,
    required String rounds,
    required String time,
    required int rating,
    required bool isRunning,
    required bool isCompleted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green.withOpacity(0.1) : (isRunning ? Colors.blue.withOpacity(0.1) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? Colors.green : (isRunning ? Colors.blue : Colors.grey[300]!),
          width: isRunning || isCompleted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise header with number and name
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green.withOpacity(0.2) : (isRunning ? Colors.blue.withOpacity(0.2) : Colors.blue.withOpacity(0.1)),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$exerciseNumber',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.green : (isRunning ? Colors.blue : Colors.blue),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    exerciseName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.green : (isRunning ? Colors.blue : Colors.black),
                    ),
                  ),
                ),
                if (isCompleted) Icon(Icons.check_circle, color: Colors.green, size: 24),
              ],
            ),

            SizedBox(height: 12),

            // Rating stars
            Row(
              children: List.generate(7, (starIndex) {
                return Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: starIndex < rating ? Colors.red : Colors.grey[300],
                  ),
                );
              }),
            ),

            SizedBox(height: 12),

            // Rounds, time, and controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rounds,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      if (isRunning)
                        Text(
                          'Running...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (isCompleted)
                        Text(
                          'Completed!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),

                // Timer controls and display
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        // Start/Stop button
                        IconButton(
                          onPressed: () {
                            if (isRunning) {
                              _stopTimer(index);
                            } else if (!isCompleted) {
                              _startTimer(index);
                            }
                          },
                          icon: Icon(
                            isCompleted ? Icons.check_circle : (isRunning ? Icons.pause : Icons.play_arrow),
                            color: isCompleted ? Colors.green : (isRunning ? Colors.red : Colors.blue),
                            size: 24,
                          ),
                        ),

                        // Timer display
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isCompleted ? Colors.green.withOpacity(0.1) : (isRunning ? Colors.blue.withOpacity(0.1) : Colors.grey[100]),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isCompleted ? Colors.green : (isRunning ? Colors.blue : Colors.grey[300]!),
                            ),
                          ),
                          child: Text(
                            time,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isCompleted ? Colors.green : (isRunning ? (_remainingTimes[index] <= 5 ? Colors.red : Colors.blue) : Colors.black),
                            ),
                          ),
                        ),

                        // Reset button
                        IconButton(
                          onPressed: () => _resetTimer(index),
                          icon: Icon(
                            Icons.replay,
                            color: Colors.orange,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      isCompleted ? 'Completed' : (isRunning ? 'Running' : 'Start'),
                      style: TextStyle(
                        fontSize: 14,
                        color: isCompleted ? Colors.green : (isRunning ? Colors.blue : Colors.blue),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
