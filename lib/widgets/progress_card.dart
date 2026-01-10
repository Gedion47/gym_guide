import 'package:flutter/material.dart';

class ProgressCard extends StatefulWidget {
  final String imagePath;
  final String exType;
  final String workoutType;
  final Map<String, int> initialData;
  final VoidCallback onRemove;

  const ProgressCard({
    super.key,
    required this.imagePath,
    required this.exType,
    required this.workoutType,
    required this.initialData,
    required this.onRemove,
  });

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  int _completed = 0;
  int _target = 0;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _target = widget.initialData['target'] ?? (widget.workoutType == 'full_body' ? 3 : 4);
    _completed = widget.initialData['completed'] ?? 0;
    _isCompleted = _completed >= _target;
  }

  @override
  void didUpdateWidget(ProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialData != oldWidget.initialData) {
      _completed = widget.initialData['completed'] ?? 0;
      _target = widget.initialData['target'] ?? _target;
      _isCompleted = _completed >= _target;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.exType,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Daily $_completed/$_target",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Green checkmark when completed
          if (_isCompleted)
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green.shade700,
                size: 24,
              ),
            ),

          // Remove button only
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey.shade600),
            onPressed: widget.onRemove,
          ),
        ],
      ),
    );
  }
}
