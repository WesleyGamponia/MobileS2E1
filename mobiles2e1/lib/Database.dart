import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

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
            `itemID` int PRIMARY KEY AUTO_INCREMENT,
            `categoryID` int,
            `itemName` varchar(64),
            `expense` double,
            `date` date
          );

          CREATE TABLE category(
            `categoryID` int PRIMARY KEY AUTO_INCREMENT,
            `title` varchar(64),
            `budget` double,
          );
          
          ''');
      },
      version: 1,
    );
  }

  newItem(newItem) async {
    final db = await database;

    var res = await db.rawInsert(
      '''
        INSERT INTO item(itemID, categoryID, itemName, expense, date) VALUES(?,?,?,?,?);
      ''',
      [newItem.itemID,newItem.categoryID,newItem.itemName,newItem.expense,newItem.date],
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
}
