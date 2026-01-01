// lib/widgets/workout_card.dart
import 'package:flutter/material.dart';

class WorkoutCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final double cardHeight;
  final double imageSize;
  final Color borderColor;
  final Color shadowColor;
  final double verticalSpacing;
  final VoidCallback? onTap;
  final String? routeName;
  final Object? arguments;

  const WorkoutCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.cardHeight = 100,
    this.imageSize = 64,
    this.verticalSpacing = 16,
    this.borderColor = const Color.fromARGB(255, 209, 209, 209),
    this.shadowColor = Colors.grey,
    this.onTap,
    this.routeName,
    this.arguments,
  });

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
      return;
    }

    if (routeName != null) {
      Navigator.pushNamed(
        context,
        routeName!,
        arguments: arguments,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: verticalSpacing),
      width: double.infinity,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _handleTap(context),
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.grey.withOpacity(0.3),
          highlightColor: Colors.grey.withOpacity(0.1),
          child: Row(
            children: [
              // Image container on left
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Title and subtitle in middle
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Arrow icon on right
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/arrow.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
