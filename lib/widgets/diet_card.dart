import 'package:flutter/material.dart';

class DietCard extends StatefulWidget {
  final String imagePath;
  final String exType;
  final String general;
  final String breakfast;
  final String lunch;
  final String dinner;
  final VoidCallback? onRemove;

  const DietCard({
    super.key,
    required this.imagePath,
    required this.exType,
    required this.general,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    this.onRemove,
  });

  @override
  _DietCardState createState() => _DietCardState();
}

class _DietCardState extends State<DietCard> {
  final bool _showOptions = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 241, 116),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(widget.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(widget.exType, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_horiz, size: 20),
                    onSelected: (value) {
                      if (value == 'remove' && widget.onRemove != null) {
                        widget.onRemove!();
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'remove',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Remove'),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "GENERAL PRINCIPLES",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(widget.general),
          ),
          SizedBox(height: 20),
          Text(
            "FULL DAY MEAL PLAN",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1),
          Text("Breakfast", style: TextStyle(fontSize: 13)),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(widget.breakfast),
          ),
          Text("Lunch", style: TextStyle(fontSize: 13)),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(widget.lunch),
          ),
          Text("Dinner", style: TextStyle(fontSize: 13)),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(widget.dinner),
          ),
        ],
      ),
    );
  }
}
