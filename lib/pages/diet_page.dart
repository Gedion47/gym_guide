import 'package:flutter/material.dart';
import '../widgets/diet_card.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  _DietPageState createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  // Track which diets are selected individually
  bool _absSelected = false;
  bool _aerobicsSelected = false;

  void _showAddDietDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Diet Plan"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Show Abs option only if not already selected
                if (!_absSelected)
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage('assets/images/abs.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text("Abs Workout"),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _absSelected = true;
                      });
                    },
                  ),
                // Show Aerobics option only if not already selected
                if (!_aerobicsSelected)
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage('assets/images/aerobics.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text("Aerobics Workout"),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _aerobicsSelected = true;
                      });
                    },
                  ),
                // If all diets are already selected, show message
                if (_absSelected && _aerobicsSelected)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "All diet plans have been added",
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

  void _removeAbsDiet() {
    setState(() {
      _absSelected = false;
    });
  }

  void _removeAerobicsDiet() {
    setState(() {
      _aerobicsSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build list of selected diet cards
    final List<Widget> dietCards = [];

    if (_absSelected) {
      dietCards.add(
        DietCard(
          imagePath: "assets/images/abs.png",
          exType: "Abs Workout",
          general: "• Protein every meal (muscle repair)\n• Complex carbs before/after training \n• Healthy fats daily (hormones + joints)\n• Hydration: 2–3 liters/day",
          breakfast: "• Scrambled eggs (2-3)\n• Oats or bread\n• Fruit (banana or apple)\n• Optional: milk or yogurt",
          lunch: "• Rice / pasta / injera\n• Chicken / lentils / meat / fish\n• Vegetables (salad, cooked cabbage, spinach)",
          dinner: "• Rice + veggies + eggs\n• Grilled fish + potatoes",
          onRemove: _removeAbsDiet,
        ),
      );
    }

    if (_aerobicsSelected) {
      dietCards.add(
        DietCard(
          imagePath: "assets/images/aerobics.png",
          exType: "Aerobics Workout",
          general: "• Protein every meal (muscle repair)\n• Complex carbs before/after training \n• Healthy fats daily (hormones + joints)\n• Hydration: 2–3 liters/day",
          breakfast: "• Scrambled eggs (2-3)\n• Oats or bread\n• Fruit (banana or apple)\n• Optional: milk or yogurt",
          lunch: "• Rice / pasta / injera\n• Chicken / lentils / meat / fish\n• Vegetables (salad, cooked cabbage, spinach)",
          dinner: "• Rice + veggies + eggs\n• Grilled fish + potatoes",
          onRemove: _removeAerobicsDiet,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diet Plan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _showAddDietDialog,
              icon: Icon(Icons.add),
              label: Text('Add Diet Plan'),
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
          Expanded(
            child: dietCards.isNotEmpty
                ? ListView(children: dietCards)
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 20),
                        Text(
                          "No Diet Plan Selected",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Tap 'Add Diet Plan' to get started",
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
