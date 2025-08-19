import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_page.dart'; // Import GameLevel from game_page.dart

class GameLevelDetailPage extends StatefulWidget {
  final GameLevel level;
  final Function(GameLevel) onLevelComplete;

  const GameLevelDetailPage({
    super.key,
    required this.level,
    required this.onLevelComplete,
  });

  @override
  State<GameLevelDetailPage> createState() => _GameLevelDetailPageState();
}

class _GameLevelDetailPageState extends State<GameLevelDetailPage> {
  late Map<String, bool> _taskCompletion;
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();
    _taskCompletion = {
      for (var task in widget.level.tasks) task: false,
    };
  }

  bool get _allTasksCompleted => _taskCompletion.values.every((completed) => completed);

  void _completeTask(String task) {
    setState(() {
      _taskCompletion[task] = true;
    });

    if (_allTasksCompleted) {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    // Special reward dialog for Garden level (Vegetable Box)
    if (widget.level.id == 1) {
      _showVegetableBoxReward();
    } else {
      _showRegularCompletionDialog();
    }
  }

  void _showVegetableBoxReward() {
    final random = DateTime.now().millisecondsSinceEpoch % 3;
    String bonusContent = '';
    IconData bonusIcon = Icons.card_giftcard;
    Color bonusColor = Colors.green;
    
    // Randomly decide what's in the vegetable box
    switch (random) {
      case 0:
        bonusContent = '🎟️ Bonus: 15% discount at Farm Market';
        bonusIcon = Icons.local_offer;
        bonusColor = Colors.orange;
        break;
      case 1:
        bonusContent = '📖 Recipe: Fresh Garden Salad';
        bonusIcon = Icons.menu_book;
        bonusColor = Colors.blue;
        // Unlock the recipe
        _unlockRecipe('Fresh Garden Salad');
        break;
      case 2:
        bonusContent = '🌱 Seeds: Rare Tomato Variety';
        bonusIcon = Icons.grass;
        bonusColor = Colors.green;
        break;
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('🎉 Level Complete!', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.brown[300]!,
                      Colors.brown[400]!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.inventory_2,
                      size: 60,
                      color: Colors.white,
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: bonusColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          bonusIcon,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'You opened the Vegetable Box!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      bonusColor.withOpacity(0.1),
                      bonusColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: bonusColor.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'You found:',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bonusContent,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: bonusColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                widget.onLevelComplete(widget.level);
                
                // Show additional snackbar about the bonus
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Vegetable Box opened! $bonusContent'),
                    backgroundColor: bonusColor,
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              child: const Text('Awesome!'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                widget.onLevelComplete(widget.level);
                
                // Show additional snackbar about the bonus
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Vegetable Box opened! $bonusContent'),
                    backgroundColor: bonusColor,
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: bonusColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Collect Reward'),
            ),
          ],
        );
      },
    );
  }

  void _showRegularCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('🎉 Level Complete!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 64,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                Text(
                  'Congratulations! You\'ve completed "${widget.level.name}"',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.card_giftcard, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Reward: ${widget.level.reward}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                widget.onLevelComplete(widget.level);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Collect Reward'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _unlockRecipe(String recipeName) async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedRecipes = prefs.getStringList('unlocked_recipes') ?? [];
    if (!unlockedRecipes.contains(recipeName)) {
      unlockedRecipes.add(recipeName);
      await prefs.setStringList('unlocked_recipes', unlockedRecipes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.level.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4CAF50).withOpacity(0.8),
                    const Color(0xFF8BC34A).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.assignment,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.level.description,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tasks to Complete:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _allTasksCompleted ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_taskCompletion.values.where((v) => v).length}/${widget.level.tasks.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...widget.level.tasks.map((task) => _buildTaskCard(task)),
            if (_allTasksCompleted) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'All tasks completed! Great job!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(String task) {
    final isCompleted = _taskCompletion[task] ?? false;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isCompleted ? 2 : 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isCompleted ? Colors.green.withOpacity(0.1) : Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : Icons.radio_button_unchecked,
                    color: isCompleted ? Colors.white : Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    task,
                    style: TextStyle(
                      fontSize: 16,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                      color: isCompleted ? Colors.grey : Colors.black87,
                    ),
                  ),
                ),
                if (!isCompleted)
                  ElevatedButton(
                    onPressed: _isCompleting ? null : () => _simulateTaskCompletion(task),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Complete'),
                  )
                else
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 32,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _simulateTaskCompletion(String task) {
    setState(() {
      _isCompleting = true;
    });

    // Show task-specific mini game or animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _TaskMiniGame(
          task: task,
          onComplete: () {
            Navigator.of(context).pop();
            _completeTask(task);
            setState(() {
              _isCompleting = false;
            });
          },
        );
      },
    );
  }
}

class _TaskMiniGame extends StatefulWidget {
  final String task;
  final VoidCallback onComplete;

  const _TaskMiniGame({
    required this.task,
    required this.onComplete,
  });

  @override
  State<_TaskMiniGame> createState() => _TaskMiniGameState();
}

class _TaskMiniGameState extends State<_TaskMiniGame> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      // duration: const Duration(seconds: 5), // Original 5 seconds animation
      duration: const Duration(seconds: 1), // TEST: 1 second for faster testing
      vsync: this,
    );
    
    // Progress animation for the linear progress bar
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    
    // Icon animation
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    _controller.forward();
    
    // Auto-complete after animation finishes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            widget.onComplete();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Get task-specific icon
  IconData _getTaskIcon() {
    final task = widget.task.toLowerCase();
    if (task.contains('plant') || task.contains('seeds')) {
      return Icons.grass;
    } else if (task.contains('water')) {
      return Icons.water_drop;
    } else if (task.contains('pick') || task.contains('harvest')) {
      return Icons.agriculture;
    } else if (task.contains('load') || task.contains('cart')) {
      return Icons.shopping_cart;
    } else if (task.contains('check')) {
      return Icons.check_circle;
    } else if (task.contains('deliver')) {
      return Icons.local_shipping;
    } else if (task.contains('arrange')) {
      return Icons.inventory_2;
    } else if (task.contains('price')) {
      return Icons.attach_money;
    } else if (task.contains('serve') || task.contains('customer')) {
      return Icons.people;
    } else if (task.contains('count') || task.contains('revenue')) {
      return Icons.calculate;
    } else if (task.contains('decorate')) {
      return Icons.palette;
    } else if (task.contains('prepare')) {
      return Icons.restaurant;
    } else if (task.contains('tell')) {
      return Icons.campaign;
    } else if (task.contains('award')) {
      return Icons.emoji_events;
    }
    return Icons.agriculture;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Completing Task...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: _animation.value * 2 * 3.14159, // Rotate during animation
                    child: Icon(
                      _getTaskIcon(),
                      size: 50,
                      color: Color.lerp(
                        const Color(0xFF8BC34A),
                        const Color(0xFF4CAF50),
                        _animation.value,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            widget.task,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(_progressAnimation.value * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Text(
                _animation.isCompleted ? 'Task Completed!' : 'Working...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _animation.isCompleted ? const Color(0xFF4CAF50) : Colors.grey[600],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}