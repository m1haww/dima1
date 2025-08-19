import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../widgets/chicken_assistant.dart';

class QRBonusPage extends StatefulWidget {
  const QRBonusPage({super.key});

  @override
  State<QRBonusPage> createState() => _QRBonusPageState();
}

class _QRBonusPageState extends State<QRBonusPage> {
  List<QRBonus> _activeBonuses = [];
  final List<QRBonus> _usedBonuses = [];

  @override
  void initState() {
    super.initState();
    _loadBonuses();
  }

  Future<void> _loadBonuses() async {
    final prefs = await SharedPreferences.getInstance();

    // Load existing bonuses from cache
    final activeBonusStrings = prefs.getStringList('active_bonuses') ?? [];
    final usedBonusStrings = prefs.getStringList('used_bonuses') ?? [];

    setState(() {
      // Load active bonuses
      _activeBonuses = activeBonusStrings
          .map((bonusString) => QRBonus.fromJson(bonusString))
          .toList();

      // Load used bonuses
      _usedBonuses.clear();
      _usedBonuses.addAll(
        usedBonusStrings
            .map((bonusString) => QRBonus.fromJson(bonusString))
            .toList(),
      );
    });

    // Generate initial bonuses only if there are no active bonuses
    if (_activeBonuses.isEmpty && _usedBonuses.isEmpty) {
      _generateInitialBonuses();
    }
  }

  Future<void> _saveBonuses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'active_bonuses',
      _activeBonuses.map((b) => b.toJson()).toList(),
    );
    await prefs.setStringList(
      'used_bonuses',
      _usedBonuses.map((b) => b.toJson()).toList(),
    );
  }

  void _generateInitialBonuses() {
    final random = math.Random();
    final bonusTypes = [
      {
        'discount': 10,
        'store': 'Farm Market "Harvest"',
        'type': 'Vegetable discount',
      },
      {
        'discount': 15,
        'store': 'Dairy Shop "Cow Bell"',
        'type': 'Dairy products discount',
      },
      {
        'discount': 20,
        'store': 'Bakery "Grain"',
        'type': 'Bread and pastries discount',
      },
      {
        'discount': 25,
        'store': 'Honey & Jam "Bee"',
        'type': 'Honey and jams discount',
      },
      {
        'discount': 12,
        'store': 'Eco Store "Nature"',
        'type': 'Organic products discount',
      },
    ];

    setState(() {
      _activeBonuses = [];
      final usedTypes = <String>{};

      while (_activeBonuses.length < 3 &&
          usedTypes.length < bonusTypes.length) {
        final bonusType = bonusTypes[random.nextInt(bonusTypes.length)];
        final type = bonusType['type'] as String;

        if (!usedTypes.contains(type)) {
          usedTypes.add(type);
          _activeBonuses.add(
            QRBonus(
              id: _generateBonusId(),
              discount: bonusType['discount'] as int,
              store: bonusType['store'] as String,
              type: type,
              expiryDate: DateTime.now().add(
                Duration(days: 7 + random.nextInt(23)),
              ),
              isUsed: false,
            ),
          );
        }
      }
    });
    _saveBonuses();
  }

  String _generateBonusId() {
    final random = math.Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      8,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  void _generateNewBonus() {
    final random = math.Random();
    final bonusTypes = [
      {
        'discount': 10,
        'store': 'Farm Market "Harvest"',
        'type': 'Vegetable discount',
      },
      {
        'discount': 15,
        'store': 'Dairy Shop "Cow Bell"',
        'type': 'Dairy products discount',
      },
      {
        'discount': 20,
        'store': 'Bakery "Grain"',
        'type': 'Bread and pastries discount',
      },
      {
        'discount': 25,
        'store': 'Honey & Jam "Bee"',
        'type': 'Honey and jams discount',
      },
      {
        'discount': 12,
        'store': 'Eco Store "Nature"',
        'type': 'Organic products discount',
      },
      {
        'discount': 30,
        'store': 'Farmers Fair',
        'type': 'Any products discount',
      },
    ];

    // Get current active bonus types
    final activeTypes = _activeBonuses.map((b) => b.type).toSet();

    // Filter available bonus types (ones not currently active)
    final availableTypes = bonusTypes
        .where((b) => !activeTypes.contains(b['type']))
        .toList();

    if (availableTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You already have all available bonus types!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final bonusType = availableTypes[random.nextInt(availableTypes.length)];
    final newBonus = QRBonus(
      id: _generateBonusId(),
      discount: bonusType['discount'] as int,
      store: bonusType['store'] as String,
      type: bonusType['type'] as String,
      expiryDate: DateTime.now().add(Duration(days: 7 + random.nextInt(23))),
      isUsed: false,
    );

    setState(() {
      _activeBonuses.add(newBonus);
    });
    _saveBonuses();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 New bonus received: ${newBonus.type}!'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  void _markBonusAsUsed(QRBonus bonus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Use bonus?'),
          content: Text(
            'Are you sure you want to mark the bonus "${bonus.type}" as used?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _activeBonuses.remove(bonus);
                  bonus.isUsed = true;
                  _usedBonuses.add(bonus);
                });
                _saveBonuses();
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Bonus marked as used'),
                    backgroundColor: Color(0xFF4CAF50),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
              child: const Text('Use'),
            ),
          ],
        );
      },
    );
  }

  void _showUsedBonusDetails(QRBonus bonus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          '${bonus.discount}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
                            bonus.type,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bonus.store,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Status: Used',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.confirmation_number,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Code: ${bonus.id}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Valid until: ${bonus.expiryDate.day}.${bonus.expiryDate.month}.${bonus.expiryDate.year}',
                            style: TextStyle(
                              color: bonus.expiryDate.isBefore(DateTime.now())
                                  ? Colors.red
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Flexible(
                        child: Text(
                          'This bonus has already been used and cannot be redeemed again',
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('🎟️ QR Bonuses'),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Used'),
            ],
          ),
          actions: [
            IconButton(
              onPressed: _generateNewBonus,
              icon: const Icon(Icons.add),
              tooltip: 'Get new bonus',
            ),
          ],
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [_buildActiveBonusesTab(), _buildUsedBonusesTab()],
            ),
            const ChickenAssistant(),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveBonusesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFD32F2F),
                  Color(0xFFF44336),
                  Color(0xFFFF5722),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF44336).withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  '🎁 Your discounts and bonuses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Show QR code at partner store checkout',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (_activeBonuses.isEmpty)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.qr_code_2, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'You don\'t have any active bonuses yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _generateNewBonus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF44336),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Get bonus'),
                  ),
                ],
              ),
            )
          else
            ...List.generate(_activeBonuses.length, (index) {
              final bonus = _activeBonuses[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildBonusCard(bonus, true),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildUsedBonusesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                const Text(
                  '📋 History of used bonuses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Previously used discounts are displayed here',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (_usedBonuses.isEmpty)
            const Center(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'You haven\'t used any bonuses yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...List.generate(_usedBonuses.length, (index) {
              final bonus = _usedBonuses[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildBonusCard(bonus, false),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildBonusCard(QRBonus bonus, bool isActive) {
    final isExpired = bonus.expiryDate.isBefore(DateTime.now());

    return Card(
      elevation: isActive ? 4 : 2,
      child: InkWell(
        onTap: !isActive ? () => _showUsedBonusDetails(bonus) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isActive ? Colors.white : Colors.grey[50],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFFF44336) : Colors.grey,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          '${bonus.discount}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
                            bonus.type,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isActive ? Colors.black : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bonus.store,
                            style: TextStyle(
                              fontSize: 14,
                              color: isActive ? Colors.grey[600] : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Valid until: ${bonus.expiryDate.day}.${bonus.expiryDate.month}.${bonus.expiryDate.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isExpired ? Colors.red : Colors.green,
                              fontWeight: isExpired
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isActive && !isExpired)
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'use') {
                            _markBonusAsUsed(bonus);
                          } else if (value == 'show_qr') {
                            _showQRCode(bonus);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            value: 'show_qr',
                            child: Row(
                              children: [
                                Icon(Icons.qr_code, size: 16),
                                SizedBox(width: 8),
                                Text('Show QR'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'use',
                            child: Row(
                              children: [
                                Icon(Icons.check, size: 16),
                                SizedBox(width: 8),
                                Text('Mark as used'),
                              ],
                            ),
                          ),
                        ],
                      )
                    else if (!isActive)
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                  ],
                ),
                if (isActive && !isExpired) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showQRCode(bonus),
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Show QR Code'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF44336),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
                if (isExpired && isActive) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.access_time, color: Colors.red, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Expired',
                          style: TextStyle(
                            color: Colors.red,
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
        ),
      ),
    );
  }

  void _showQRCode(QRBonus bonus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bonus.type,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  bonus.store,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: QrImageView(
                    data:
                        'FARM_BONUS:${bonus.id}:${bonus.discount}:${bonus.store}',
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Code: ${bonus.id}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Discount: ${bonus.discount}%',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFF44336),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _markBonusAsUsed(bonus);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Use'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class QRBonus {
  final String id;
  final int discount;
  final String store;
  final String type;
  final DateTime expiryDate;
  bool isUsed;

  QRBonus({
    required this.id,
    required this.discount,
    required this.store,
    required this.type,
    required this.expiryDate,
    required this.isUsed,
  });

  String toJson() {
    return '$id|$discount|$store|$type|${expiryDate.millisecondsSinceEpoch}|$isUsed';
  }

  static QRBonus fromJson(String json) {
    final parts = json.split('|');
    return QRBonus(
      id: parts[0],
      discount: int.parse(parts[1]),
      store: parts[2],
      type: parts[3],
      expiryDate: DateTime.fromMillisecondsSinceEpoch(int.parse(parts[4])),
      isUsed: parts[5] == 'true',
    );
  }
}
