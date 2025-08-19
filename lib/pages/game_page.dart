import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_level_detail_page.dart';
import '../widgets/chicken_assistant.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _currentLevel = 1;
  int _score = 0;
  List<String> _inventory = [];
  bool _bonusLevelUnlocked = false;
  List<int> _completedLevels = [];

  final List<GameLevel> _levels = [
    GameLevel(
      id: 1,
      name: '🌱 Garden',
      description: 'Harvest vegetables',
      tasks: ['Plant seeds', 'Water plants', 'Pick tomatoes', 'Pick cucumbers'],
      reward: 'Vegetable Box',
    ),
    GameLevel(
      id: 2,
      name: '🏘️ Village',
      description: 'Transport cart with harvest',
      tasks: [
        'Load cart',
        'Check wheels',
        'Deliver to village center',
        'Unload goods',
      ],
      reward: 'Dairy Products',
    ),
    GameLevel(
      id: 3,
      name: '🏪 Market',
      description: 'Choose best products for sale',
      tasks: [
        'Arrange goods',
        'Set prices',
        'Serve customers',
        'Count revenue',
      ],
      reward: 'Gold Coins',
    ),
    GameLevel(
      id: 4,
      name: '🎪 Fair',
      description: 'Participate in farmer fair',
      tasks: [
        'Decorate stall',
        'Prepare tasting',
        'Tell about products',
        'Get award',
      ],
      reward: 'Best Farmer Cup',
    ),
  ];

  final GameLevel _bonusLevel = GameLevel(
    id: 5,
    name: '🌟 Secret Farm',
    description: 'Special bonus challenge!',
    tasks: [
      'Find golden seeds',
      'Water with magic potion',
      'Harvest rainbow vegetables',
      'Unlock treasure chest',
    ],
    reward: 'Magic Seeds (+500 points)',
    isBonus: true,
  );

  @override
  void initState() {
    super.initState();
    _loadGameProgress();
  }

  Future<void> _loadGameProgress() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _currentLevel = prefs.getInt('current_level') ?? 1;
      _score =
          prefs.getInt('user_points') ?? 0; // Use same key as Harvest Wheel
      _inventory = prefs.getStringList('inventory') ?? [];
      _bonusLevelUnlocked = prefs.getBool('bonus_level_unlocked') ?? false;
      _completedLevels =
          prefs
              .getStringList('completed_levels')
              ?.map((e) => int.parse(e))
              .toList() ??
          [];
    });
  }

  Future<void> _saveGameProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_level', _currentLevel);
    await prefs.setInt('user_points', _score); // Use same key as Harvest Wheel
    await prefs.setStringList('inventory', _inventory);
    await prefs.setBool('bonus_level_unlocked', _bonusLevelUnlocked);
    await prefs.setStringList(
      'completed_levels',
      _completedLevels.map((e) => e.toString()).toList(),
    );
  }

  void unlockBonusLevel() {
    setState(() {
      _bonusLevelUnlocked = true;
    });
    _saveGameProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎮 Farm Road'),
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
                    const Icon(Icons.star, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '$_score',
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
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1B5E20),
                        Color(0xFF2E7D32),
                        Color(0xFF4CAF50),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '🚜 Farm Road Map',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Choose your farming adventure!',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...List.generate(_levels.length, (index) {
                  final level = _levels[index];
                  final isUnlocked = true; // All levels are always unlocked
                  final isCompleted = _completedLevels.contains(
                    level.id,
                  ); // Show completion status
                  final isCurrent = true; // All levels are always playable

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildLevelCard(
                      level,
                      isUnlocked,
                      isCompleted,
                      isCurrent,
                    ),
                  );
                }),
                if (_bonusLevelUnlocked) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFD700),
                          Color(0xFFFFA500),
                          Color(0xFFFF8C00),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 24),
                        SizedBox(width: 8),
                        Text(
                          '🎁 BONUS LEVEL UNLOCKED!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildLevelCard(
                    _bonusLevel,
                    true, // isUnlocked - always true when bonus level is shown
                    _completedLevels.contains(
                      _bonusLevel.id,
                    ), // isCompleted - check if bonus level is completed
                    !_completedLevels.contains(
                      _bonusLevel.id,
                    ), // isCurrent - only playable if not completed
                  ),
                ],
                if (_inventory.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Text(
                    '🎒 Inventory:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: _inventory
                        .map(
                          (item) => Chip(
                            label: Text(item),
                            backgroundColor: const Color(
                              0xFF4CAF50,
                            ).withOpacity(0.1),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          const ChickenAssistant(),
        ],
      ),
    );
  }

  Widget _buildLevelCard(
    GameLevel level,
    bool isUnlocked,
    bool isCompleted,
    bool isCurrent,
  ) {
    final isBonus = level.isBonus == true;

    return Card(
      elevation: isCurrent ? 12 : 6,
      shadowColor: isBonus
          ? Colors.orange.withOpacity(0.3)
          : isCurrent
          ? const Color(0xFF4CAF50).withOpacity(0.3)
          : Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isBonus
              ? const LinearGradient(
                  colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : isCurrent
              ? const LinearGradient(
                  colors: [Color(0xFFE8F5E8), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          border: isBonus
              ? Border.all(color: Colors.orange, width: 3)
              : isCurrent
              ? Border.all(color: const Color(0xFF4CAF50), width: 3)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: isCompleted
                          ? const LinearGradient(
                              colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                            )
                          : isCurrent
                          ? const LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                            )
                          : LinearGradient(
                              colors: [Colors.grey[400]!, Colors.grey[300]!],
                            ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: (isCompleted || isCurrent)
                              ? const Color(0xFF4CAF50).withOpacity(0.3)
                              : Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isCompleted ? Icons.check_circle : Icons.play_arrow,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isUnlocked ? Colors.black : Colors.grey,
                          ),
                        ),
                        Text(
                          level.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: isUnlocked ? Colors.grey[600] : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isUnlocked) ...[
                const SizedBox(height: 12),
                const Text(
                  'Tasks:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...level.tasks.map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_right,
                          size: 16,
                          color: Color(0xFF4CAF50),
                        ),
                        const SizedBox(width: 8),
                        Text(task),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (isCompleted) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Completed! Received: ${level.reward}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _playLevel(level),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      isCompleted ? 'Play Again' : 'Play',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _playLevel(GameLevel level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            GameLevelDetailPage(level: level, onLevelComplete: _completeLevel),
      ),
    );
  }

  void _completeLevel(GameLevel level) {
    setState(() {
      // Mark level as completed for visual tracking
      if (!_completedLevels.contains(level.id)) {
        _completedLevels.add(level.id);

        // Set current level to max unlocked level (all levels available)
        if (_currentLevel < _levels.length) {
          _currentLevel = _levels.length;
        }
      }

      // Always add rewards (farming allowed)
      if (level.isBonus == true) {
        _score += 500; // Bonus level gives 500 points
      } else {
        _score += 100;
      }
      _inventory.add(level.reward);
    });

    // Unlock recipes based on level completed
    _unlockRecipeForLevel(level);

    _saveGameProgress();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Level completed! Received: ${level.reward}'),
        backgroundColor: level.isBonus == true
            ? Colors.orange
            : const Color(0xFF4CAF50),
      ),
    );
  }

  Future<void> _unlockRecipeForLevel(GameLevel level) async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedRecipes = prefs.getStringList('unlocked_recipes') ?? [];
    String? recipeToUnlock;

    // Define which recipes to unlock for each level
    List<String> recipesToUnlock = [];

    switch (level.id) {
      case 1: // Garden level - Unlock special recipes
        recipesToUnlock = ['Fresh Garden Salad', 'Honey Cake'];
        break;
      case 2: // Village level
        recipesToUnlock = ['Homemade Yogurt'];
        break;
      case 3: // Market level
        recipesToUnlock = ['Strawberry Jam'];
        break;
      case 4: // Fair level
        recipesToUnlock = ['Honey Cake'];
        break;
      case 5: // Bonus level
        if (level.isBonus == true) {
          recipesToUnlock = ['Berry Smoothie'];
        }
        break;
    }

    // Unlock all recipes for this level
    List<String> newlyUnlocked = [];
    for (String recipeToUnlock in recipesToUnlock) {
      if (!unlockedRecipes.contains(recipeToUnlock)) {
        unlockedRecipes.add(recipeToUnlock);
        newlyUnlocked.add(recipeToUnlock);
      }
    }

    // Save updated recipe list
    if (newlyUnlocked.isNotEmpty) {
      await prefs.setStringList('unlocked_recipes', unlockedRecipes);

      // Show notification about recipe unlocks
      if (newlyUnlocked.length == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '📖 Recipe unlocked: ${newlyUnlocked.first}! Check Recipes page',
            ),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '📖 ${newlyUnlocked.length} recipes unlocked: ${newlyUnlocked.join(", ")}! Check Recipes page',
            ),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _showDebugInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedRecipes = prefs.getStringList('unlocked_recipes') ?? [];
    final completedLevels =
        prefs
            .getStringList('completed_levels')
            ?.map((e) => int.parse(e))
            .toList() ??
        [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🔧 Debug Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Completed Levels: ${completedLevels.join(", ")}'),
              const SizedBox(height: 8),
              const Text('Unlocked Recipes:'),
              ...unlockedRecipes.map((recipe) => Text('- $recipe')),
              if (unlockedRecipes.isEmpty) const Text('- None unlocked'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Force unlock all recipes for testing
                  await prefs.setStringList('unlocked_recipes', [
                    'Fresh Garden Salad',
                    'Homemade Yogurt',
                    'Strawberry Jam',
                    'Honey Cake',
                    'Berry Smoothie',
                  ]);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🔓 All recipes force unlocked!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Force Unlock All Recipes'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  // Apply Garden level recipe unlocking retroactively
                  final currentUnlocked =
                      prefs.getStringList('unlocked_recipes') ?? [];
                  final gardenRecipes = ['Fresh Garden Salad', 'Honey Cake'];
                  final newRecipes = <String>[];

                  for (String recipe in gardenRecipes) {
                    if (!currentUnlocked.contains(recipe)) {
                      currentUnlocked.add(recipe);
                      newRecipes.add(recipe);
                    }
                  }

                  if (newRecipes.isNotEmpty) {
                    await prefs.setStringList(
                      'unlocked_recipes',
                      currentUnlocked,
                    );
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '🌱 Garden recipes unlocked: ${newRecipes.join(", ")}!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🌱 Garden recipes already unlocked!'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                child: const Text('Fix Garden Recipes'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class GameLevel {
  final int id;
  final String name;
  final String description;
  final List<String> tasks;
  final String reward;
  final bool? isBonus;

  GameLevel({
    required this.id,
    required this.name,
    required this.description,
    required this.tasks,
    required this.reward,
    this.isBonus,
  });
}
