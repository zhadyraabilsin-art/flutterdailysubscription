import 'package:flutter/material.dart';

void main() {
  runApp(const SubscriptionTrackerApp());
}

class SubscriptionTrackerApp extends StatelessWidget {
  const SubscriptionTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Subscription Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const SubscriptionScreen(),
    );
  }
}

class SubscriptionItem {
  final String id;
  final String name;
  final double monthlyCost;
  final String billingDay;
  final String category;
  bool isActive;

  SubscriptionItem({
    required this.id,
    required this.name,
    required this.monthlyCost,
    required this.billingDay,
    required this.category,
    this.isActive = true,
  });
}

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final List<SubscriptionItem> _subs = [
    SubscriptionItem(
      id: '1',
      name: 'GitHub Copilot',
      monthlyCost: 10.00,
      billingDay: '5th of month',
      category: 'Dev Tools',
      isActive: true,
    ),
    SubscriptionItem(
      id: '2',
      name: 'Spotify Premium',
      monthlyCost: 4.99,
      billingDay: '12th of month',
      category: 'Music',
      isActive: true,
    ),
    SubscriptionItem(
      id: '3',
      name: 'iCloud+ 200GB',
      monthlyCost: 2.99,
      billingDay: '19th of month',
      category: 'Cloud',
      isActive: true,
    ),
    SubscriptionItem(
      id: '4',
      name: 'Gym Membership',
      monthlyCost: 35.00,
      billingDay: '1st of month',
      category: 'Fitness',
      isActive: false,
    ),
  ];

  final _nameController = TextEditingController();
  final _costController = TextEditingController();
  final _dayController = TextEditingController(text: '15th of month');
  String _selectedCategory = 'Entertainment';

  double get _totalMonthly => _subs
      .where((s) => s.isActive)
      .fold(0.0, (sum, item) => sum + item.monthlyCost);

  double get _totalYearly => _totalMonthly * 12;

  void _addSubscription() {
    final name = _nameController.text.trim();
    final cost = double.tryParse(_costController.text.trim()) ?? 0.0;
    final day = _dayController.text.trim();

    if (name.isEmpty || cost <= 0) return;

    setState(() {
      _subs.insert(
        0,
        SubscriptionItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          monthlyCost: cost,
          billingDay: day.isEmpty ? 'Monthly' : day,
          category: _selectedCategory,
        ),
      );
    });

    _nameController.clear();
    _costController.clear();
    Navigator.of(context).pop();
  }

  void _openAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Add Subscription',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Service Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _costController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Monthly Price (\$)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _dayController,
                    decoration: const InputDecoration(
                      labelText: 'Billing Date',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        [
                              'Entertainment',
                              'Dev Tools',
                              'Music',
                              'Cloud',
                              'Fitness',
                            ]
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                    onChanged: (val) {
                      if (val != null)
                        setModalState(() => _selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _addSubscription,
                    child: const Text('Save Subscription'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Tracker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.indigo.shade800,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Monthly Total',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${_totalMonthly.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 40, color: Colors.white24),
                  Column(
                    children: [
                      const Text(
                        'Yearly Estimate',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${_totalYearly.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _subs.length,
                itemBuilder: (ctx, index) {
                  final sub = _subs[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: sub.isActive
                            ? Colors.indigo.shade100
                            : Colors.grey.shade200,
                        child: Icon(
                          Icons.subscriptions,
                          color: sub.isActive ? Colors.indigo : Colors.grey,
                        ),
                      ),
                      title: Text(
                        sub.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: sub.isActive ? null : Colors.grey,
                        ),
                      ),
                      subtitle: Text('${sub.category} • ${sub.billingDay}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${sub.monthlyCost.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: sub.isActive
                                  ? Colors.indigo.shade900
                                  : Colors.grey,
                            ),
                          ),
                          Switch(
                            value: sub.isActive,
                            onChanged: (val) =>
                                setState(() => sub.isActive = val),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
