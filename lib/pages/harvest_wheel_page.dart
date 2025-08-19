import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../widgets/chicken_assistant.dart';

class HarvestWheelPage extends StatefulWidget {
  const HarvestWheelPage({super.key});

  @override
  State<HarvestWheelPage> createState() => _HarvestWheelPageState();
}

class _HarvestWheelPageState extends State<HarvestWheelPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<double>? _rotationAnimation;

  bool _isSpinning = false;
  String _lastResult = '';
  int _userPoints = 0;

  final List<WheelSegment> _segments = [
    WheelSegment(
      text: '+50 points',
      color: const Color(0xFF4CAF50),
      icon: Icons.stars,
    ),
    WheelSegment(
      text: 'Honey Cake Recipe',
      color: const Color(0xFF2196F3),
      icon: Icons.restaurant,
    ),
    WheelSegment(
      text: '+100 points',
      color: const Color(0xFFFF9800),
      icon: Icons.star,
    ),
    WheelSegment(
      text: 'Bonus level',
      color: const Color(0xFF9C27B0),
      icon: Icons.games,
    ),
    WheelSegment(
      text: 'QR discount 10%',
      color: const Color(0xFFF44336),
      icon: Icons.qr_code,
    ),
    WheelSegment(
      text: 'Surprise',
      color: const Color(0xFF795548),
      icon: Icons.card_giftcard,
    ),
    WheelSegment(
      text: '+25 points',
      color: const Color(0xFF607D8B),
      icon: Icons.monetization_on,
    ),
    WheelSegment(
      text: 'Berry Smoothie Recipe',
      color: const Color(0xFF00BCD4),
      icon: Icons.book,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _loadUserPoints();
  }

  Future<void> _loadUserPoints() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userPoints = prefs.getInt('user_points') ?? 0;
    });
  }

  Future<void> _saveUserPoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_points', _userPoints);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (_isSpinning) return;

    setState(() {
      _isSpinning = true;
    });

    final random = math.Random();
    final spins = 5 + random.nextDouble() * 5; // 5-10 оборотов
    final finalAngle = spins * 2 * math.pi;

    _rotationAnimation = Tween<double>(begin: 0, end: finalAngle).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.reset();
    _animationController.forward().then((_) {
      final segmentAngle = 2 * math.pi / _segments.length;
      final normalizedAngle = (finalAngle % (2 * math.pi));
      final segmentIndex =
          ((2 * math.pi - normalizedAngle) / segmentAngle).floor() %
          _segments.length;

      final result = _segments[segmentIndex];

      setState(() {
        _isSpinning = false;
        _lastResult = result.text;
      });

      _showResultDialog(result);
    });
  }

  void _showResultDialog(WheelSegment result) async {
    // Apply the prize
    await _applyPrize(result);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🎉 Congratulations!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(result.icon, size: 64, color: result.color),
              const SizedBox(height: 16),
              Text(
                'You won:',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                result.text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (result.text.contains('points')) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Total Points: $_userPoints',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Excellent!'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _applyPrize(WheelSegment result) async {
    final prefs = await SharedPreferences.getInstance();

    if (result.text.contains('points')) {
      // Extract points from text
      final pointsMatch = RegExp(r'\+(\d+) points').firstMatch(result.text);
      if (pointsMatch != null) {
        final points = int.parse(pointsMatch.group(1)!);
        setState(() {
          _userPoints += points;
        });
        await _saveUserPoints();
      }
    } else if (result.text.contains('Recipe')) {
      // Unlock recipe
      final unlockedRecipes = prefs.getStringList('unlocked_recipes') ?? [];
      String recipeName = '';

      if (result.text.contains('Honey Cake')) {
        recipeName = 'Honey Cake';
      } else if (result.text.contains('Berry Smoothie')) {
        recipeName = 'Berry Smoothie';
      }

      if (recipeName.isNotEmpty && !unlockedRecipes.contains(recipeName)) {
        unlockedRecipes.add(recipeName);
        await prefs.setStringList('unlocked_recipes', unlockedRecipes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 $recipeName recipe unlocked! Check Recipes page'),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else if (result.text.contains('QR discount')) {
      // Generate QR discount code only if not already active
      await _generateQRDiscount();
    } else if (result.text.contains('Bonus level')) {
      // Unlock bonus level
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('bonus_level_unlocked', true);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎮 Secret Farm bonus level unlocked in Farm Road!'),
          backgroundColor: Colors.purple,
          duration: Duration(seconds: 3),
        ),
      );
    } else if (result.text.contains('Surprise')) {
      // Random surprise - could be points or recipe
      final random = math.Random();
      if (random.nextBool()) {
        setState(() {
          _userPoints += 75;
        });
        await _saveUserPoints();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎁 Surprise: You got 75 bonus points!'),
            backgroundColor: Colors.brown,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎁 Surprise: Extra spin unlocked!'),
            backgroundColor: Colors.brown,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _generateQRDiscount() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load current active bonuses
    final activeBonusStrings = prefs.getStringList('active_bonuses') ?? [];
    final activeTypes = <String>{};
    
    // Parse active bonus types
    for (final bonusString in activeBonusStrings) {
      final parts = bonusString.split('|');
      if (parts.length >= 4) {
        activeTypes.add(parts[3]); // type is at index 3
      }
    }
    
    // Check if QR discount 10% is already active
    if (activeTypes.contains('QR Discount from Wheel')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You already have this QR discount active!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    
    // Generate new QR discount
    final random = math.Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final bonusId = List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
    
    final newBonus = 'WHEEL$bonusId|10|Farm Market "Harvest"|QR Discount from Wheel|${DateTime.now().add(const Duration(days: 14)).millisecondsSinceEpoch}|false';
    
    activeBonusStrings.add(newBonus);
    await prefs.setStringList('active_bonuses', activeBonusStrings);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎟️ New 10% QR discount added! Check QR Bonuses'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎡 Harvest Wheel'),
        centerTitle: true,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.only(right: 8),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '$_userPoints',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2E7D32),
                      Color(0xFF4CAF50),
                      Color(0xFF66BB6A),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.casino,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Spin the harvest wheel!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Get random bonuses, points and recipes',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      spreadRadius: 2,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _rotationAnimation?.value ?? 0.0,
                                child: CustomPaint(
                                  size: const Size(300, 300),
                                  painter: WheelPainter(_segments),
                                ),
                              );
                            },
                          ),
                          // Center circle
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          // Pointer
                          Positioned(
                            top: 5,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF388E3C), Color(0xFF4CAF50)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isSpinning ? null : _spinWheel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isSpinning
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Spinning...',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          'SPIN',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                ),
              ),
              if (_lastResult.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Last result:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _lastResult,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'Possible prizes:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _segments
                    .map(
                      (segment) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: segment.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: segment.color.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(segment.icon, size: 16, color: segment.color),
                            const SizedBox(width: 6),
                            Text(
                              segment.text,
                              style: TextStyle(
                                color: segment.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
          const ChickenAssistant(),
        ],
      ),
    );
  }
}

class WheelSegment {
  final String text;
  final Color color;
  final IconData icon;

  WheelSegment({required this.text, required this.color, required this.icon});
}

class WheelPainter extends CustomPainter {
  final List<WheelSegment> segments;

  WheelPainter(this.segments);

  String _getEmojiForSegment(WheelSegment segment) {
    if (segment.text.contains('50 points')) return '⭐';
    if (segment.text.contains('100 points')) return '💎';
    if (segment.text.contains('25 points')) return '✨';
    if (segment.text.contains('Honey Cake')) return '🍰';
    if (segment.text.contains('Berry Smoothie')) return '🥤';
    if (segment.text.contains('Bonus level')) return '🎮';
    if (segment.text.contains('QR discount')) return '🎫';
    if (segment.text.contains('Surprise')) return '🎁';
    return '🌟';
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segmentAngle = 2 * math.pi / segments.length;

    for (int i = 0; i < segments.length; i++) {
      final startAngle = i * segmentAngle - math.pi / 2;
      final sweepAngle = segmentAngle;

      final paint = Paint()
        ..color = segments[i].color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw borders
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      // Draw emoji
      final emojiAngle = startAngle + sweepAngle / 2;
      final emojiRadius = radius * 0.75;
      final emojiCenter = Offset(
        center.dx + emojiRadius * math.cos(emojiAngle),
        center.dy + emojiRadius * math.sin(emojiAngle),
      );

      final emojiPainter = TextPainter(
        text: TextSpan(
          text: _getEmojiForSegment(segments[i]),
          style: const TextStyle(
            fontSize: 36,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      emojiPainter.layout();

      canvas.save();
      canvas.translate(emojiCenter.dx, emojiCenter.dy);
      emojiPainter.paint(
        canvas,
        Offset(-emojiPainter.width / 2, -emojiPainter.height / 2),
      );
      canvas.restore();

      // Draw smaller text below emoji
      final textRadius = radius * 0.45;
      final textCenter = Offset(
        center.dx + textRadius * math.cos(emojiAngle),
        center.dy + textRadius * math.sin(emojiAngle),
      );

      String shortText = '';
      if (segments[i].text.contains('points')) {
        shortText = segments[i].text.replaceAll(' points', '');
      } else if (segments[i].text.contains('10%')) {
        shortText = '10%';
      }

      if (shortText.isNotEmpty) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: shortText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 3,
                  color: Colors.black38,
                ),
              ],
            ),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        canvas.save();
        canvas.translate(textCenter.dx, textCenter.dy);
        canvas.rotate(emojiAngle + math.pi / 2);
        textPainter.paint(
          canvas,
          Offset(-textPainter.width / 2, -textPainter.height / 2),
        );
        canvas.restore();
      }
    }

    // Рисуем центральный круг
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 20, centerPaint);

    final centerBorderPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, 20, centerBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
