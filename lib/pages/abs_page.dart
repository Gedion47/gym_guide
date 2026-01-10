import 'package:flutter/material.dart';
import '../widgets/exercise.dart';

class AbsWorkoutPage extends StatefulWidget {
  const AbsWorkoutPage({super.key});

  @override
  State<AbsWorkoutPage> createState() => _AbsWorkoutPageState();
}

class _AbsWorkoutPageState extends State<AbsWorkoutPage> {
  final List<Map<String, dynamic>> exercises = [
    {
      'name': '1. Crunches',
      'gif': 'assets/gifs/Crunches.gif',
      'preview': 'assets/images/Crunches.png',
      'info': '20 rounds, 30 seconds',
      'time': 30,
    },
    {
      'name': '2. Hanging Leg Raises',
      'gif': 'assets/gifs/Hanging_Leg_Raises.gif',
      'preview': 'assets/images/Hanging_Leg_Raises.png',
      'info': '15 rounds, 40 seconds',
      'time': 40,
    },
    {
      'name': '3. Standing Toe Touch',
      'gif': 'assets/gifs/Standing_Toe_Touch.gif',
      'preview': 'assets/images/Standing_Toe_Touch.png',
      'info': '20 rounds, 45 seconds',
      'time': 45,
    },
    {
      'name': '4. Plank',
      'gif': 'assets/gifs/Plank.gif',
      'preview': 'assets/images/Plank.png',
      'info': '3 sets, 60 seconds',
      'time': 60,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('assets/images/abs.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Text(
              'Abs Workout',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.star, color: Colors.amber, size: 20),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final e = exercises[index];
            return ExerciseCard(
              exerciseName: e['name'],
              gifPath: e['gif'],
              previewImagePath: e['preview'],
              roundsInfo: e['info'],
              timerSeconds: e['time'],
              workoutType: 'abs',
            );
          },
        ),
      ),
    );
  }
}
