// Nathan Perez
// 100754066
// Assignment 3 Mobile

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  // Get the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create the food_items table
        await db.execute('''
        CREATE TABLE food_items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          price REAL NOT NULL
        )
      ''');

        // Create the orders table
        await db.execute('''
        CREATE TABLE orders (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          food_items_list TEXT NOT NULL,
          date TEXT NOT NULL
        )
      ''');

        // Populate the food_items table with 20 entries
        await db.insert('food_items', {'name': 'Apple', 'price': 0.99});
        await db.insert('food_items', {'name': 'Banana', 'price': 0.59});
        await db.insert('food_items', {'name': 'Orange', 'price': 0.79});
        await db.insert('food_items', {'name': 'Grapes', 'price': 1.49});
        await db.insert('food_items', {'name': 'Watermelon', 'price': 3.99});
        await db.insert('food_items', {'name': 'Strawberry', 'price': 2.99});
        await db.insert('food_items', {'name': 'Mango', 'price': 1.99});
        await db.insert('food_items', {'name': 'Blueberry', 'price': 3.49});
        await db.insert('food_items', {'name': 'Pineapple', 'price': 2.99});
        await db.insert('food_items', {'name': 'Avocado', 'price': 1.49});
        await db.insert('food_items', {'name': 'Carrot', 'price': 0.39});
        await db.insert('food_items', {'name': 'Broccoli', 'price': 0.99});
        await db.insert('food_items', {'name': 'Tomato', 'price': 0.69});
        await db.insert('food_items', {'name': 'Cucumber', 'price': 0.49});
        await db.insert('food_items', {'name': 'Potato', 'price': 0.29});
        await db.insert('food_items', {'name': 'Onion', 'price': 0.59});
        await db.insert('food_items', {'name': 'Lettuce', 'price': 0.99});
        await db.insert('food_items', {'name': 'Spinach', 'price': 1.29});
        await db.insert('food_items', {'name': 'Peach', 'price': 1.19});
        await db.insert('food_items', {'name': 'Pear', 'price': 1.09});
      },
    );
  }


  // Insert a new food item
  Future<void> insertFoodItem(String name, double price) async {
    final db = await database;
    await db.insert(
      'food_items',
      {'name': name, 'price': price},
    );
  }

  // Get all food items
  Future<List<Map<String, dynamic>>> getFoodItems() async {
    final db = await database;
    return await db.query('food_items');
  }

  Future<void> insertOrder(String name, double price) async {
    final db = await database;
    await db.insert(
      'orders', // Table name
      {
        'name': name,
        'price': price,
      }, // Data to insert
    );
  }

  // Get all orders
  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;
    return await db.query('orders');
  }

  Future<Map<String, dynamic>?> searchFoodItem(String? query) async {
    if (query == null || query.isEmpty) {
      query = "Pizza"; // Debugging, remove or modify before submitting
    }
    final db = await database;
    final result = await db.query(
      'food_items', // Table name
      where: 'name = ?', // Search by name
      whereArgs: [query], // Query argument
      limit: 1, // Get only one result
    );
    return result.isNotEmpty ? result.first : null; // Return the first result or null
  }





}
