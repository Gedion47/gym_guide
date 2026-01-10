import 'package:flutter/material.dart';
import '../widgets/exercise.dart';

class FullBodyWorkoutPage extends StatefulWidget {
  const FullBodyWorkoutPage({super.key});

  @override
  State<FullBodyWorkoutPage> createState() => _FullBodyWorkoutPageState();
}

class _FullBodyWorkoutPageState extends State<FullBodyWorkoutPage> {
  final List<Map<String, dynamic>> exercises = [
    {
      'name': '1. Push Up',
      'gif': 'assets/gifs/Push_Up.gif',
      'preview': 'assets/images/Push_Up.png',
      'info': '20 rounds, 30 seconds',
      'time': 30,
    },
    {
      'name': '2. Pull Up',
      'gif': 'assets/gifs/Pull_Up.gif',
      'preview': 'assets/images/Pull_Up.png',
      'info': '15 rounds, 40 seconds',
      'time': 30,
    },
    {
      'name': '3. Lunge',
      'gif': 'assets/gifs/Reverse_Lunge_Knee.gif',
      'preview': 'assets/images/Reverse_Lunge_Knee.png',
      'info': '10 rounds each leg, 40 seconds',
      'time': 30,
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
                  image: AssetImage('assets/images/full_body.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Text(
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
            );
          },
        ),
      ),
    );
  }
}
