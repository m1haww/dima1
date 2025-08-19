import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/chicken_assistant.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  List<String> _unlockedRecipes = [];

  final List<String> _categories = [
    'All',
    '🥗 Salads',
    '🍞 Bread',
    '🧀 Cheese',
    '🥛 Dairy',
    '🍯 Jams',
    '🥤 Drinks',
  ];

  @override
  void initState() {
    super.initState();
    _loadUnlockedRecipes();
  }

  Future<void> _loadUnlockedRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _unlockedRecipes = prefs.getStringList('unlocked_recipes') ?? [];
    });
  }

  final List<Recipe> _recipes = [
    Recipe(
      name: 'Farm Tomato Vegetable Salad',
      category: '🥗 Salads',
      ingredients: [
        '2 large tomatoes',
        '1 cucumber',
        '1 bell pepper',
        '50g herbs (dill, parsley)',
        '2 tbsp olive oil',
        'Salt, pepper to taste',
      ],
      instructions: [
        'Cut tomatoes into large slices',
        'Cut cucumber into half-rings',
        'Cut pepper into strips',
        'Finely chop herbs',
        'Mix all ingredients',
        'Season with oil, salt and pepper',
        'Let stand for 10 minutes',
      ],
      prepTime: '15 minutes',
      difficulty: 'Easy',
      image: '🥗',
    ),
    Recipe(
      name: 'Fresh Garden Salad',
      category: '🥗 Salads',
      ingredients: [
        '2 cups mixed lettuce',
        '1 cup cherry tomatoes',
        '1/2 cucumber',
        '1/4 red onion',
        '1/2 cup croutons',
        '3 tbsp balsamic vinaigrette',
        'Fresh basil leaves',
      ],
      instructions: [
        'Wash and dry all vegetables',
        'Tear lettuce into bite-sized pieces',
        'Halve cherry tomatoes',
        'Slice cucumber and red onion thinly',
        'Combine all vegetables in a large bowl',
        'Add croutons and fresh basil',
        'Drizzle with vinaigrette just before serving',
        'Toss gently and serve immediately',
      ],
      prepTime: '15 minutes',
      difficulty: 'Easy',
      image: '🥗',
      isSpecial: true,
    ),
    Recipe(
      name: 'Homemade Sourdough Bread',
      category: '🍞 Bread',
      ingredients: [
        '500g wheat flour',
        '350ml warm water',
        '100g sourdough starter',
        '10g salt',
        '1 tsp sugar',
      ],
      instructions: [
        'Mix starter with warm water',
        'Add flour and salt',
        'Knead dough, let rest 30 minutes',
        'Do folds every 30 minutes (4 times)',
        'Leave to rise for 4-6 hours',
        'Shape bread, let rise 2 hours',
        'Bake at 230°C for 45 minutes',
      ],
      prepTime: '8 hours',
      difficulty: 'Hard',
      image: '🍞',
    ),
    Recipe(
      name: 'Farm Cottage Cheese',
      category: '🧀 Cheese',
      ingredients: [
        '1 liter whole milk',
        '2 tbsp lemon juice',
        '1 tsp salt',
        'Herbs optional',
      ],
      instructions: [
        'Heat milk to 80°C',
        'Add lemon juice',
        'Wait for curd formation',
        'Strain through cheesecloth',
        'Add salt and herbs',
        'Press out excess whey',
        'Chill in refrigerator 2 hours',
      ],
      prepTime: '3 hours',
      difficulty: 'Medium',
      image: '🧀',
    ),
    Recipe(
      name: 'Strawberry Jam',
      category: '🍯 Jams',
      ingredients: [
        '1 kg fresh strawberries',
        '800g sugar',
        '2 tbsp lemon juice',
        '1 packet vanilla sugar',
      ],
      instructions: [
        'Clean and slice strawberries',
        'Cover with sugar, leave overnight',
        'Bring to boil on low heat',
        'Cook 15 minutes, removing foam',
        'Add lemon juice and vanilla',
        'Cook another 5 minutes',
        'Pour into sterilized jars',
      ],
      prepTime: '12 hours',
      difficulty: 'Medium',
      image: '🍓',
    ),
    Recipe(
      name: 'Green Cucumber Smoothie',
      category: '🥤 Drinks',
      ingredients: [
        '1 cucumber',
        '1 green apple',
        '50g spinach',
        '200ml yogurt',
        '1 tbsp honey',
        'Ice optional',
      ],
      instructions: [
        'Peel and chop cucumber and apple',
        'Wash spinach',
        'Put all ingredients in blender',
        'Blend until smooth',
        'Add ice when serving',
        'Serve immediately',
      ],
      prepTime: '10 minutes',
      difficulty: 'Easy',
      image: '🥤',
    ),
    Recipe(
      name: 'Homemade Yogurt',
      category: '🥛 Dairy',
      ingredients: [
        '1 liter milk',
        '2 tbsp plain yogurt',
        '2 tbsp powdered milk (optional)',
      ],
      instructions: [
        'Heat milk to 85°C',
        'Cool to 45°C',
        'Add yogurt starter',
        'Mix thoroughly',
        'Pour into jars',
        'Place in yogurt maker or warm place for 8 hours',
        'Chill in refrigerator',
      ],
      prepTime: '10 hours',
      difficulty: 'Medium',
      image: '🥛',
    ),
    Recipe(
      name: 'Honey Cake',
      category: '🍞 Bread',
      ingredients: [
        '3 cups flour',
        '1 cup honey',
        '4 eggs',
        '1 cup sugar',
        '1 cup sour cream',
        '1 tsp baking soda',
        '2 cups heavy cream for filling',
      ],
      instructions: [
        'Mix honey, sugar, and eggs in a pot',
        'Heat gently while stirring until sugar dissolves',
        'Add baking soda and mix well',
        'Remove from heat and add flour gradually',
        'Divide dough into 8 parts and roll thin',
        'Bake each layer at 180°C for 5-7 minutes',
        'Whip cream and layer between cake layers',
        'Refrigerate overnight before serving',
      ],
      prepTime: '2 hours + overnight',
      difficulty: 'Hard',
      image: '🍰',
      isSpecial: true,
    ),
    Recipe(
      name: 'Berry Smoothie',
      category: '🥤 Drinks',
      ingredients: [
        '1 cup mixed berries',
        '1 banana',
        '1 cup yogurt',
        '1/2 cup milk',
        '2 tbsp honey',
        'Ice cubes',
        'Mint leaves for garnish',
      ],
      instructions: [
        'Wash and prepare all berries',
        'Peel and slice banana',
        'Add berries, banana, yogurt to blender',
        'Pour in milk and honey',
        'Blend until smooth and creamy',
        'Add ice and blend again',
        'Pour into glasses and garnish with mint',
        'Serve immediately',
      ],
      prepTime: '10 minutes',
      difficulty: 'Easy',
      image: '🥤',
      isSpecial: true,
    ),
  ];

  List<Recipe> get _filteredRecipes {
    return _recipes.where((recipe) {
      final matchesCategory =
          _selectedCategory == 'All' || recipe.category == _selectedCategory;
      final matchesSearch =
          recipe.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          recipe.ingredients.any(
            (ingredient) =>
                ingredient.toLowerCase().contains(_searchQuery.toLowerCase()),
          );
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📚 Farm Recipes'), centerTitle: true),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1565C0),
                      Color(0xFF2196F3),
                      Color(0xFF21CBF3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2196F3).withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      '🍽️ Cook with natural products!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search recipes or ingredients...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: const Color(0xFF2196F3).withOpacity(0.2),
                        checkmarkColor: const Color(0xFF2196F3),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: _filteredRecipes.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No recipes found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = _filteredRecipes[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildRecipeCard(recipe),
                          );
                        },
                      ),
              ),
            ],
          ),
          const ChickenAssistant(),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    final isLocked =
        recipe.isSpecial == true && !_unlockedRecipes.contains(recipe.name);

    return Card(
      elevation: 8,
      shadowColor: isLocked
          ? Colors.grey.withOpacity(0.2)
          : const Color(0xFF2196F3).withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: isLocked
            ? () => _showLockedDialog()
            : () => _showRecipeDetails(recipe),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: isLocked
                  ? [Colors.grey[100]!, Colors.grey[50]!]
                  : [Colors.white, const Color(0xFF2196F3).withOpacity(0.02)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF2196F3).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: recipe.imagePath.isNotEmpty
                              ? Image.asset(
                                  recipe.imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(
                                              0xFF2196F3,
                                            ).withOpacity(0.1),
                                            const Color(
                                              0xFF2196F3,
                                            ).withOpacity(0.05),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          recipe.image,
                                          style: const TextStyle(fontSize: 32),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(
                                          0xFF2196F3,
                                        ).withOpacity(0.1),
                                        const Color(
                                          0xFF2196F3,
                                        ).withOpacity(0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      recipe.image,
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              recipe.category,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  recipe.prepTime,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  _getDifficultyIcon(recipe.difficulty),
                                  size: 16,
                                  color: _getDifficultyColor(recipe.difficulty),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  recipe.difficulty,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getDifficultyColor(
                                      recipe.difficulty,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ingredients: ${recipe.ingredients.take(3).join(', ')}${recipe.ingredients.length > 3 ? '...' : ''}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
              if (isLocked)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.9),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock, size: 32, color: Colors.grey[600]),
                            const SizedBox(height: 4),
                            Text(
                              'Locked Recipe',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Complete levels',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
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

  IconData _getDifficultyIcon(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Icons.sentiment_very_satisfied;
      case 'Medium':
        return Icons.sentiment_neutral;
      case 'Hard':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.help;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showRecipeDetails(Recipe recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2196F3).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: recipe.imagePath.isNotEmpty
                            ? Image.asset(
                                recipe.imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(
                                      0xFF2196F3,
                                    ).withOpacity(0.1),
                                    child: Center(
                                      child: Text(
                                        recipe.image,
                                        style: const TextStyle(fontSize: 36),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: const Color(0xFF2196F3).withOpacity(0.1),
                                child: Center(
                                  child: Text(
                                    recipe.image,
                                    style: const TextStyle(fontSize: 36),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(recipe.prepTime),
                              const SizedBox(width: 16),
                              Icon(
                                _getDifficultyIcon(recipe.difficulty),
                                size: 16,
                                color: _getDifficultyColor(recipe.difficulty),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                recipe.difficulty,
                                style: TextStyle(
                                  color: _getDifficultyColor(recipe.difficulty),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Ingredients:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...recipe.ingredients.map(
                  (ingredient) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 6,
                          color: Color(0xFF2196F3),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(ingredient)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Instructions:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...recipe.instructions.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2196F3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(entry.value)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLockedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('🔒 Recipe Locked'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'This special recipe can be unlocked by completing levels in the Farm Road game!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.tips_and_updates,
                      color: Color(0xFF4CAF50),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: const Text(
                        'Bonus Level: Unlocks Berry Smoothie (only way to get it)',
                        style: TextStyle(
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.bold,
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
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class Recipe {
  final String name;
  final String category;
  final List<String> ingredients;
  final List<String> instructions;
  final String prepTime;
  final String difficulty;
  final String image;
  final bool? isSpecial;

  String get imagePath {
    // Map recipe names to their image file names with proper extensions
    switch (name) {
      case 'Berry Smoothie':
        return 'images/Berry Smoothie.jpg';
      case 'Farm Cottage Cheese':
        return 'images/Farm Cottage Cheese.webp';
      case 'Farm Tomato Vegetable Salad':
        return 'images/Farm Tomato Vegetable Salad.webp';
      case 'Fresh Garden Salad':
        return 'images/Fresh Garden Salad.webp';
      case 'Green Cucumber Smoothie':
        return 'images/Green Cucumber Smoothie.webp';
      case 'Homemade Sourdough Bread':
        return 'images/Homemade Sourdough Bread.jpg';
      case 'Homemade Yogurt':
        return 'images/Homemade Yogurt.jpg';
      case 'Honey Cake':
        return 'images/Honey Cake.jpeg';
      case 'Strawberry Jam':
        return 'images/Strawberry Jam.jpg';
      default:
        return '';
    }
  }

  Recipe({
    required this.name,
    required this.category,
    required this.ingredients,
    required this.instructions,
    required this.prepTime,
    required this.difficulty,
    required this.image,
    this.isSpecial,
  });
}
