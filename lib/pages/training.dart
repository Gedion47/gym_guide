import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_guide/pages/chest_page.dart';
import 'package:gym_guide/pages/full_body_page.dart';
import 'package:gym_guide/pages/diet_page.dart';
import 'package:gym_guide/pages/profile_page.dart';
import 'package:gym_guide/pages/progress_page.dart';
import 'package:gym_guide/pages/abs_page.dart';
import 'package:gym_guide/widgets/workout_card.dart';
import 'package:gym_guide/services/premium_service.dart';
import 'package:gym_guide/services/auth_provider.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _tabController.addListener(() {
      if (_currentIndex != _tabController.index) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    final List<Widget> tabPages = [
      // ================= TRAINING TAB =================
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Gym Guide',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : const AssetImage('assets/images/profile.png') as ImageProvider,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
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
                      builder: (_) => const FullBodyWorkoutPage(),
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
                      builder: (_) => const ChestWorkoutPage(),
                    ),
                  );
                },
              ),
              WorkoutCard(
                imagePath: 'assets/images/back.png',
                title: 'Back Workout',
                subtitle: '3 exercises',
                onTap: () {},
              ),

              // Locked Abs Workout Card
              FutureBuilder<bool>(
                future: PremiumService.isPremiumUnlocked(),
                builder: (context, snapshot) {
                  final isPremiumUnlocked = snapshot.data ?? false;

                  return WorkoutCard(
                    imagePath: 'assets/images/abs.png',
                    title: 'Abs Workout',
                    subtitle: '4 exercises',
                    isLocked: !isPremiumUnlocked,
                    onTap: isPremiumUnlocked
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AbsWorkoutPage(),
                              ),
                            );
                          }
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // PROGRESS TAB
      const ProgressPage(),

      // DIET TAB
      const DietPage(),

      // PROFILE TAB
      const ProfilePage(),
    ];

    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        children: tabPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          _tabController.animateTo(index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
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
        ],
      ),
    );
  }
}
