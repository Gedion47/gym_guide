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
                backgroundImage: AssetImage('assets/images/profile.png'), // User image
                backgroundColor: Colors.grey[300], // Fallback if no image
              ),
            ),
          ),
        ],
        centerTitle: false,
        backgroundColor: Colors.white,
        //elevation: 2,
        foregroundColor: Colors.black,
      ),

      // body: Padding(
      //   padding: const EdgeInsets.all(30.0),
      //   child: Column(
      //     children: [
      //       Expanded(
      //         child: ListView(
      //           children: [
      //             Container(
      //               width: double.infinity,
      //               height: 100,
      //               decoration: BoxDecoration(
      //                 color: Colors.white,
      //                 borderRadius: BorderRadius.circular(10),
      //                 border: Border.all(
      //                   color: Colors.grey,
      //                   width: 2,
      //                 ),
      //                 boxShadow: [
      //                   BoxShadow(
      //                     color: Colors.grey.withOpacity(0.3),
      //                     spreadRadius: 0,
      //                     blurRadius: 8,
      //                     offset: Offset(4, 4), // Right and bottom shadow
      //                   ),
      //                 ],
      //               ),
      //               child: Stack(
      //                 children: [
      //                   Row(
      //                     children: [
      //                       Padding(
      //                         padding: EdgeInsets.all(16.0),
      //                         child: Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             Container(
      //                               width: 64,
      //                               height: 64,
      //                               decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.circular(10),
      //                                 image: DecorationImage(
      //                                   image: AssetImage("assets/images/full_body.png"),
      //                                   fit: BoxFit.cover,
      //                                 ),
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                       Expanded(
      //                         child: Padding(
      //                           padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      //                           child: Column(
      //                             crossAxisAlignment: CrossAxisAlignment.start,
      //                             children: [
      //                               Text(
      //                                 'Full Body Workout',
      //                                 style: TextStyle(
      //                                   fontSize: 20,
      //                                   fontWeight: FontWeight.bold,
      //                                   color: Colors.black,
      //                                 ),
      //                               ),
      //                               Text(
      //                                 '3 exercises',
      //                                 style: TextStyle(
      //                                   fontSize: 15,
      //                                   color: Colors.grey,
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                       Padding(
      //                         padding: EdgeInsets.all(20),
      //                         child: Row(
      //                           children: [
      //                             Container(
      //                               width: 30,
      //                               height: 30,
      //                               decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.circular(50),
      //                                 image: DecorationImage(
      //                                   image: AssetImage("assets/images/arrow.png"),
      //                                   fit: BoxFit.cover,
      //                                 ),
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
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
