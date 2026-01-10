import 'package:flutter/material.dart';
import '../widgets/diet_card.dart';
import '../services/data_service.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  _DietPageState createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  bool _absSelected = false;
  bool _aerobicsSelected = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // load selections from DataService
    final absSelected = await DataService.loadDietSelection(DataService.absDietKey);
    final aerobicsSelected = await DataService.loadDietSelection(DataService.aerobicsDietKey);

    if (mounted) {
      setState(() {
        _absSelected = absSelected;
        _aerobicsSelected = aerobicsSelected;
        _isLoading = false;
      });
    }
  }

  void _showAddDietDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Diet Plan"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (!_absSelected)
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/chest.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: const Text("Chest Workout"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _addAbsDiet();
                    },
                  ),
                if (!_aerobicsSelected)
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/full_body.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: const Text("Full Body Workout"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _addAerobicsDiet();
                    },
                  ),
                if (_absSelected && _aerobicsSelected)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
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
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addAbsDiet() async {
    setState(() {
      _absSelected = true;
    });

    await DataService.saveDietSelection(DataService.absDietKey, true);
  }

  Future<void> _addAerobicsDiet() async {
    setState(() {
      _aerobicsSelected = true;
    });

    await DataService.saveDietSelection(DataService.aerobicsDietKey, true);
  }

  Future<void> _removeAbsDiet() async {
    setState(() {
      _absSelected = false;
    });

    await DataService.saveDietSelection(DataService.absDietKey, false);
  }

  Future<void> _removeAerobicsDiet() async {
    setState(() {
      _aerobicsSelected = false;
    });

    await DataService.saveDietSelection(DataService.aerobicsDietKey, false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Diet Plan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final List<Widget> dietCards = [];

    if (_absSelected) {
      dietCards.add(
        DietCard(
          imagePath: "assets/images/chest.png",
          exType: "Chest Workout",
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
          imagePath: "assets/images/full_body.png",
          exType: "Full Body Workout",
          general: "• Protein every meal (muscle repair)\n• Complex carbs before/after training \n• Healthy fats daily (hormones + joints)\n• Hydration: 2–3 liters/day",
          breakfast: "• Scrambled eggs (2-3)\n• Oats or bread\n• Fruit (banana or apple)\n• Optional: milk or yogurt",
          lunch: "• Rice / pasta / injera\n• Chicken / lentils / meat / fish\n• Vegetables (salad, cooked cabbage, spinach)",
          dinner: "• Rice + veggies + eggs\n• Grilled fish + potatoes",
          onRemove: _removeAerobicsDiet,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
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
              icon: const Icon(Icons.add),
              label: const Text('Add Diet Plan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: dietCards.isNotEmpty
                ? ListView(children: dietCards)
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 20),
                        Text(
                          "No Diet Plan Selected",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
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
