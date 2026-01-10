import 'package:flutter/material.dart';
import '../widgets/exercise.dart';

class ChestWorkoutPage extends StatefulWidget {
  const ChestWorkoutPage({super.key});

  @override
  State<ChestWorkoutPage> createState() => _ChestWorkoutPageState();
}

class _ChestWorkoutPageState extends State<ChestWorkoutPage> {
  final List<Map<String, dynamic>> exercises = [
    {
      'name': '1. Incline Dumbbell Press',
      'gif': 'assets/gifs/Incline_Dumbbell_Press.gif',
      'preview': 'assets/images/Incline_Dumbbell_Press.png',
      'info': '10 rounds, 20 seconds',
      'time': 20,
    },
    {
      'name': '2. Chest Dips',
      'gif': 'assets/gifs/Chest_Dips.gif',
      'preview': 'assets/images/Chest_Dips.png',
      'info': '15 rounds, 30 seconds',
      'time': 30,
    },
    {
      'name': '3. Chest Press Machine',
      'gif': 'assets/gifs/Chest_Press_Machine.gif',
      'preview': 'assets/images/Chest_Press_Machine.png',
      'info': '20 rounds each leg, 30 seconds',
      'time': 30,
    },
    {
      'name': '4. Pec Deck Fly',
      'gif': 'assets/gifs/Pec_Deck_Fly.gif',
      'preview': 'assets/images/Pec_Deck_Fly.png',
      'info': '20 rounds each leg, 20 seconds',
      'time': 20,
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
                  image: AssetImage('assets/images/chest.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Text(
              'Chest Workout',
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
