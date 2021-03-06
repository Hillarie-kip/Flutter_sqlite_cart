import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/models/Cart.dart';

class DatabaseHelper {

	static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
	static Database _database;                // Singleton Database

	String orderItemTable = 'OrderItem';

	String colID='ID';
	String colOrderID = 'OrderID';
	String colProductName= 'ProductName';
	String colProductID= 'ProductID';
	String colProviderID= 'ProviderID';
	String colProviderName= 'ProviderName';
	String colProductImage= 'ProductImage';
	String colProductPrice= 'ProductPrice';
	String colQuantity= 'Quantity';
	String colDateTime= 'DateTime';



	DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

	factory DatabaseHelper() {

		if (_databaseHelper == null) {
			_databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
		}
		return _databaseHelper;
	}

	Future<Database> get database async {

		if (_database == null) {
			_database = await initializeDatabase();
		}
		return _database;
	}



	Future<Database> initializeDatabase() async {
		// Get the directory path for both Android and iOS to store database.
		Directory directory = await getApplicationDocumentsDirectory();
		String path = directory.path + 'notes.db';

		// Open/create the database at a given path
		var notesDatabase = await openDatabase(path, version: 3, onCreate: _createDb);
		return notesDatabase;
	}

	void _createDb(Database db, int newVersion) async {

		await db.execute('CREATE TABLE $orderItemTable($colID INTEGER PRIMARY KEY AUTOINCREMENT, $colOrderID NVARCHAR(20), '
				'$colProviderID INTEGER, $colProviderName INTEGER, '
				'$colProductID INTEGER,$colProductName NVARCHAR(20),$colProductImage NVARCHAR(20), '
				'$colProductPrice INTEGER,$colQuantity INTEGER,$colDateTime NVARCHAR(20)  )');
	}

	// Fetch Operation: Get all note objects from database
	Future<List<Map<String, dynamic>>> getCartMapList(String orderID) async {
		Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
		var result = await db.query(orderItemTable,where:'$colOrderID= $orderID ' ,orderBy: '$colQuantity ASC');
		return result;
	}

	// Insert Operation: Insert a Note object to database
	Future<int> insertCart(Cart note) async {
		Database db = await this.database;
		var result = await db.insert(orderItemTable, note.toMap());
		return result;
	}

	// Update Operation: Update a Note object and save it to database
	Future<int> updateCart(Cart note) async {
		var db = await this.database;
		var result = await db.update(orderItemTable, note.toMap(), where: '$colID = ?', whereArgs: [note.id]);
		return result;
	}

	Future<int> updateQuantityCart(int id,int newquantity) async {
		var db = await this.database;
		int result = await db.rawDelete('UPDATE  $orderItemTable SET $colQuantity=$newquantity WHERE $colID = $id');
		return result;
	}


	// Delete Operation: Delete a Note object from database
	Future<int> deleteCartItem(int id) async {
		var db = await this.database;
		int result = await db.rawDelete('DELETE FROM $orderItemTable WHERE $colID = $id');
		return result;
	}

	// Get number of Note objects in database
	Future<int> getCartCount() async {
		Database db = await this.database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $orderItemTable');
		int result = Sqflite.firstIntValue(x);
		return result;
	}

	Future<int> getTotalProduct() async {
		Database db = await this.database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT SUM(Quantity) from $orderItemTable');
		int result = Sqflite.firstIntValue(x);
		return result;
	}
	Future<int> getTotalPrice() async {
		Database db = await this.database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT SUM(Quantity*ProductPrice)Total from $orderItemTable');
		int result = Sqflite.firstIntValue(x);
		return result;

	}

	Future calculateTotal() async {
		var dbClient = await this.database;
		var result = await dbClient.rawQuery("SELECT SUM(Quantity*ProductPrice)Total from $orderItemTable");
		print(result);
		return result;
	}

	Future DeleteOrderItems() async {
		var dbClient = await database;
		await dbClient.transaction((txn) async {
			await txn.execute("DELETE FROM $orderItemTable");
		//	await txn.execute("DELETE FROM Posts");
		});
	}

	// Get the 'Map List' [ List<Map> ] and convert it to 'Product List' [ List<Product> ]
	Future<List<Cart>> getNoteList(String orderID) async {

		var noteMapList = await getCartMapList(orderID); // Get 'Map List' from database
		int count = noteMapList.length;         // Count the number of map entries in db table

		List<Cart> noteList = List<Cart>();
		// For loop to create a 'Note List' from a 'Map List'
		for (int i = 0; i < count; i++) {
			noteList.add(Cart.fromMapObject(noteMapList[i]));
		}

		return noteList;
	}






}







