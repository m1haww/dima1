import 'package:flutter/material.dart';

class ChickenAssistant extends StatefulWidget {
  final List<String>? customHints;
  
  const ChickenAssistant({super.key, this.customHints});

  @override
  State<ChickenAssistant> createState() => _ChickenAssistantState();
}

class _ChickenAssistantState extends State<ChickenAssistant> {
  bool _showHint = false;
  String _currentHint = '';

  List<String> get _hints => widget.customHints ?? _defaultHints;

  static final List<String> _defaultHints = [
    "🌱 Start with the Garden level to harvest fresh vegetables!",
    "🎯 Complete all tasks in a level to earn rewards!",
    "⭐ Each level gives you 100 points when completed!",
    "🎁 The bonus level gives you 500 points!",
    "📖 Completing levels unlocks new recipes!",
    "🥕 Garden level unlocks Fresh Garden Salad and Honey Cake recipes!",
    "🥛 Village level unlocks Homemade Yogurt recipe!",
    "🍓 Market level unlocks Strawberry Jam recipe!",
    "🍯 Fair level unlocks special Honey Cake recipe!",
    "✨ Play levels multiple times to farm more rewards!",
    "🎮 All levels are playable - choose your favorite!",
    "🏆 Check your inventory to see all collected rewards!",
    "💡 Tap on any level to see its tasks before playing!",
    "🌟 Look for the bonus level - it has special rewards!",
    "🚜 Each level represents a step in the farming journey!",
    "🎰 Try the Harvest Wheel for bonus points!",
    "📱 Scan QR codes for special bonuses!",
    "🍳 Check the Recipes page for delicious farm recipes!",
    "🏡 Welcome to your farming adventure!",
    "💰 Collect points to unlock more features!",
  ];

  void _showChickenHint() {
    setState(() {
      _currentHint = _hints[DateTime.now().millisecond % _hints.length];
      _showHint = true;
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showHint = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 20,
          right: 20,
          child: GestureDetector(
            onTap: _showChickenHint,
            child: SizedBox(
              width: 90,
              height: 90,
              child: ClipOval(
                child: Image.asset(
                  'images/assistent.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.yellow[100],
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.help_outline,
                        size: 40,
                        color: Colors.orange,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        if (_showHint)
          Positioned(
            bottom: 120,
            left: 20,
            right: 100,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '🐔 Chicken Helper',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.orange,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showHint = false;
                          });
                        },
                        child: const Icon(Icons.close, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_currentHint, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}