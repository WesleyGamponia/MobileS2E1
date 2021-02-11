import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import 'models/budgetDetail.dart';
class DBProvider {
  
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'expenseTracker.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE item(
            `id` int PRIMARY KEY AUTO_INCREMENT,
            `categoryID` int,
            `title` varchar(64),
            `amount` double,
            `date` date
          );

          CREATE TABLE category(
            `categoryID` int PRIMARY KEY AUTO_INCREMENT,
            `title` varchar(64),
            `amount` double,
          );
          
          ''');
      },
      version: 1,
    );
  }

  newItem(Item newItem) async {
    final db = await database;

    var res = await db.rawInsert(
      '''
        INSERT INTO item(itemID, categoryID, itemName, expense, date) VALUES(?,?,?,?,?);
      ''',
      [newItem.categoryID,newItem.title,newItem.amount,newItem.date],
    );
    return res;
  }

  Future<dynamic> getItem()async{
    final db= await database;

    var res = await db.query("item");
    if(res.length == 0){
      return null;
    }else {
      var resMap=res[0];
      return resMap.isNotEmpty ? resMap : Null;
    }
  }
  newCategory(Budget newCategory) async {
    final db = await database;

    var res = await db.rawInsert(
      '''
        INSERT INTO category(categoryID, amount, date) VALUES(?,?,?);
      ''',
      //[newCategory.id,newCategory.title,newCategory.amount],
    );
    return res;
  }

  Future<dynamic> getCategory()async{
    final db= await database;

    var res = await db.query("category");
    if(res.length == 0){
      return null;
    }else {
      var resMap=res[0];
      return resMap.isNotEmpty ? resMap : Null;
    }
  }
}
