import 'package:flutter/material.dart';
import 'game_page.dart';
import 'harvest_wheel_page.dart';
import 'recipes_page.dart';
import 'qr_bonus_page.dart';
import 'settings_page.dart';
import '../widgets/chicken_assistant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const GamePage(),
    const HarvestWheelPage(),
    const RecipesPage(),
    const QRBonusPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: const Color(0xFF2E7D32),
          unselectedItemColor: Colors.grey[400],
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.games),
              label: 'Farm Road',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.casino),
              label: 'Harvest Wheel',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: 'Recipes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'QR Bonus',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  void _navigateToPage(BuildContext context, int index) {
    final homePageState = context.findAncestorStateOfType<_HomePageState>();
    homePageState?.setState(() {
      homePageState._selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Road - Farmer\'s Path'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2E7D32),
                        Color(0xFF4CAF50),
                        Color(0xFF8BC34A),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.agriculture,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Welcome to the Farm!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          'Play, learn recipes and get bonuses',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Main Sections:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildFeatureCard(
                  icon: Icons.games,
                  title: '🎮 Farm Road',
                  description:
                      'Complete levels: garden → village → market → fair',
                  color: const Color(0xFFFF9800),
                  onTap: () => _navigateToPage(context, 1),
                ),
                const SizedBox(height: 12),
                _buildFeatureCard(
                  icon: Icons.casino,
                  title: '🎡 Harvest Wheel',
                  description:
                      'Spin the wheel and get random bonuses and recipes',
                  color: const Color(0xFF9C27B0),
                  onTap: () => _navigateToPage(context, 2),
                ),
                const SizedBox(height: 12),
                _buildFeatureCard(
                  icon: Icons.restaurant,
                  title: '📚 Farm Recipes',
                  description:
                      'Catalog of healthy dishes from natural products',
                  color: const Color(0xFF2196F3),
                  onTap: () => _navigateToPage(context, 3),
                ),
                const SizedBox(height: 12),
                _buildFeatureCard(
                  icon: Icons.qr_code,
                  title: '🎟️ QR Bonuses',
                  description: 'Get discounts at partner stores',
                  color: const Color(0xFFF44336),
                  onTap: () => _navigateToPage(context, 4),
                ),
              ],
            ),
          ),
          const ChickenAssistant(),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
