// Nathan Perez
// 100754066
// Assignment 3 Mobile


import 'package:flutter/material.dart';
import 'db_helper.dart'; // Import database helper

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures async operations before runApp
  final dbHelper = DatabaseHelper();
  await dbHelper.database; // Initialize the database
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Order App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper(); // Database helper
  final TextEditingController _costController = TextEditingController(); // Controller for cost input
  final TextEditingController _searchController = TextEditingController(); // Controller for search input
  final TextEditingController _foodNameController = TextEditingController(); // Controller for food name
  final TextEditingController _priceController = TextEditingController(); // Controller for price



  int? _targetCost; // Store the target cost
  String? _selectedDate; // Store the full selected date

  String? _foodName; // To display food name
  double? _foodPrice; // To display food price

  // Variables for date selection
  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;

  // Dropdown options
  final List<String> _days = List.generate(31, (index) => (index + 1).toString());
  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  final List<String> _years = List.generate(100, (index) => (2020 + index).toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Nathan`s Food Ordering App')),
    body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView(
    child: Column(
    children: [
            // Target Cost Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _costController,
                    keyboardType: TextInputType.number, // Only allow numbers
                    decoration: const InputDecoration(
                      labelText: 'Enter Target Cost per Day',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final cost = int.tryParse(_costController.text);
                    if (cost != null) {
                      setState(() {
                        _targetCost = cost;
                      });
                    }
                  },
                  child: const Text('Set'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Display Current Limit
            Text(
              _targetCost != null
                  ? 'Current limit is: \$$_targetCost'
                  : 'No limit set yet.',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),

            // Date Selection Dropdowns
            Wrap(
              spacing: 8.0, // Space between items
              runSpacing: 8.0, // Space between rows (if wrapped)
              alignment: WrapAlignment.center, // Center align items
              children: [
                // Day Dropdown
                SizedBox(
                  width: 100, // Fixed width
                  child: DropdownButtonFormField<String>(
                    value: _selectedDay,
                    decoration: const InputDecoration(
                      labelText: 'Day',
                      border: OutlineInputBorder(),
                    ),
                    items: _days.map((day) {
                      return DropdownMenuItem(
                        value: day,
                        child: Text(day),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDay = value;
                      });
                    },
                  ),
                ),
                // Month Dropdown
                SizedBox(
                  width: 130, // Fixed width
                  child: DropdownButtonFormField<String>(
                    value: _selectedMonth,
                    decoration: const InputDecoration(
                      labelText: 'Month',
                      border: OutlineInputBorder(),
                    ),
                    items: _months.map((month) {
                      return DropdownMenuItem(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMonth = value;
                      });
                    },
                  ),
                ),
                // Year Dropdown
                SizedBox(
                  width: 100, // Fixed width
                  child: DropdownButtonFormField<String>(
                    value: _selectedYear,
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(),
                    ),
                    items: _years.map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedYear = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Set Date Button
            ElevatedButton(
              onPressed: () {
                if (_selectedDay != null && _selectedMonth != null && _selectedYear != null) {
                  setState(() {
                    _selectedDate = '$_selectedDay $_selectedMonth $_selectedYear';
                  });
                }
              },
              child: const Text('Set Date'),
            ),
            const SizedBox(height: 16),

            // Display Selected Date
            Text(
              _selectedDate != null
                  ? 'The current date is: $_selectedDate'
                  : 'No date set yet.',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),

            // Search Section
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Food Item',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (query) async {
                print('Searching for: $query');
                final result = await dbHelper.searchFoodItem(query); // Query database
                print('Search result: $result');
                if (result != null) {
                  setState(() {
                    _foodName = result['name'];
                    _foodPrice = result['price'];
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Item Not Found'),
                      content: const Text('The food item does not exist.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            // Static Labels with Dynamic Data
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Food Name:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  _foodName ?? 'Not Available', // Provide a default value if _foodName is null
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Price:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  _foodPrice != null ? '\$${_foodPrice!.toStringAsFixed(5)}' : 'Not Available',
                  style: const TextStyle(fontSize: 18),
                ),

              ],
            ),

      const SizedBox(height: 32),

      // New Section for Food Name and Price
      const Text(
        'Add New Food Item',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),

      // Food Name Text Field
      TextField(
        controller: _foodNameController,
        decoration: const InputDecoration(
          labelText: 'Food Name',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 16),

      // Price Text Field
      TextField(
        controller: _priceController,
        keyboardType: TextInputType.number, // Only allow numbers
        decoration: const InputDecoration(
          labelText: 'Price',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 16),

      // Buttons to Add to Orders and Food Items
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              final name = _foodNameController.text.trim();
              final price = double.tryParse(_priceController.text.trim());
              if (price != null) {
                dbHelper.insertOrder(name, price);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid price.')),
                );
              }
            },
            child: const Text('Add to Orders'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _foodNameController.text.trim();
              final price = double.tryParse(_priceController.text.trim());
              if (price != null) {
                dbHelper.insertFoodItem(name, price);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid price.')),
                );
              }
            },
            child: const Text('Add to Food Items'),
          ),
        ],
      ),
    ],
    ),
    ),
    ),
    );
  }
}
