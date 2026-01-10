import 'package:flutter/material.dart';
import 'dart:async';

class ExerciseCard extends StatefulWidget {
  final String exerciseName;
  final String gifPath;
  final String previewImagePath;
  final String roundsInfo;
  final int timerSeconds;

  const ExerciseCard({
    super.key,
    required this.exerciseName,
    required this.gifPath,
    required this.previewImagePath,
    required this.roundsInfo,
    required this.timerSeconds,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _isRunning = false;
  bool _playGif = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.timerSeconds;
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _secondsRemaining = widget.timerSeconds;
      _playGif = true; // GIF starts on start button
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _playGif = false; // GIF stops when timer ends
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.exerciseName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  _playGif ? widget.gifPath : widget.previewImagePath,
                  height: 250,
                  width: 250,
                  fit: BoxFit.contain,
                  cacheWidth: 300, // keeps memory safe and avoids crashing
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.roundsInfo,
                style: const TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1877F2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size.fromHeight(40),
                      ),
                      onPressed: _startTimer,
                      child: const Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        _formattedTime,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
