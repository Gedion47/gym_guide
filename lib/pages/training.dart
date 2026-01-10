import 'package:flutter/material.dart';
import 'package:gym_guide/pages/full_body_page.dart';
import 'package:gym_guide/widgets/workout_card.dart';
import 'package:gym_guide/pages/login.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  int _currentIndex = 0;

  // Bottom navigation items
  final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.fitness_center),
      label: 'Training',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.trending_up),
      label: 'Progress',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.restaurant),
      label: 'Diet',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gym Guide',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => {},
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/profile.png'),
                backgroundColor: Colors.grey[300], // Fallback if no image
              ),
            ),
          ),
        ],
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  WorkoutCard(
                    imagePath: 'assets/images/full_body.png',
                    title: 'Full Body Workout',
                    subtitle: '3 exercises',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullBodyWorkoutPage(),
                        ),
                      );
                    },
                  ),
                  WorkoutCard(
                    imagePath: 'assets/images/chest.png',
                    title: 'Chest Workout',
                    subtitle: '4 exercises',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                  ),
                  WorkoutCard(
                    imagePath: 'assets/images/back.png',
                    title: 'Back Workout',
                    subtitle: '3 exercises',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Handle navigation to other pages
          // You'll need to implement navigation for Progress, Diet, Profile pages
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: _navItems,
      ),
    );
  }
}
