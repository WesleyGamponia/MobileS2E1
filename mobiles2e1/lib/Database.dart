
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'models/budgetDetail.dart';

class DBProvider {
  static const String TABLE_CATEGORY = 'category';
  static const String CATEGORY_ID = 'catID';
  static const String CATEGORY_NAME = 'catName';
  static const String CATEGORY_BUDGET = 'budget';
  static const String CATEGORY_EXPENSE = 'catExpense';
  

  static const String TABLE_ITEM = 'item';
  static const String ITEM_ID = 'itemID';
  static const String ITEM_CATEGORY = 'catID';
  static const String ITEM_NAME = 'itemName';
  static const String ITEM_EXPENSE = 'itemExpense';
  static const String ITEM_DATE = 'itemDate';

  DBProvider._();
  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await createDB();
    return _database;
  }

  Future<Database> createDB() async {
    String dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'trackerDB1.db'),
      version: 1,
      onCreate: (Database database, int version)async{
        await database.execute(
          '''
          CREATE TABLE $TABLE_CATEGORY (
            $CATEGORY_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $CATEGORY_NAME varchar(64),
            $CATEGORY_BUDGET double,
            $CATEGORY_EXPENSE double
            );
          '''
        );
        await database.execute(
          '''
          CREATE TABLE $TABLE_ITEM(
            $ITEM_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $ITEM_CATEGORY INTEGER,
            $ITEM_NAME varchar(64),
            $ITEM_EXPENSE double,
            $ITEM_DATE date
          );
          '''
        );
      }
    );
  }

  Future<List<Budget>>getCategory()async{
    final db=await database;
    var categories = await db.query(
      TABLE_CATEGORY,
      columns: [CATEGORY_ID,CATEGORY_NAME,CATEGORY_BUDGET],
    );
    List<Budget> categoryList = List<Budget>();

    categories.forEach((currentCategory) { 
      Budget category = Budget.fromMap(currentCategory);

      categoryList.add(category);
    });

    return categoryList;
  }
  
  Future<Budget> insertCategory (Budget category) async {
    final db = await database;

    category.id = await db.insert(TABLE_CATEGORY, category.toMap());
    return category;
  }

// static const String TABLE_ITEM = 'item';
//   static const String ITEM_ID = 'itemID';
//   static const String ITEM_CATEGORY = 'catID';
//   static const String ITEM_NAME = 'itemName';
//   static const String ITEM_EXPENSE = 'itemExpense';
//   static const String ITEM_DATE = 'itemDate';
  Future<List<Item>>getItem()async{
    final db=await database;
    var items = await db.query(
      TABLE_ITEM,
      columns: [ITEM_ID,ITEM_NAME,ITEM_EXPENSE,ITEM_CATEGORY,ITEM_DATE],
    );
    List<Item> itemList = List<Item>();

    items.forEach((currentItem) { 
      Item item = Item.fromMap(currentItem);

      itemList.add(item);
    });

    return itemList;
  }
  
  Future<Item> insertItem (Item item) async {
    final db = await database;

    item.id = await db.insert(TABLE_ITEM, item.toMap());
    return item;
  }

  // Future getExpense(int index)async{
  //   final db= await database;
    
  //   var res = await db.rawQuery(
  //      "SELECT SUM(itemExpense) as Total from item where catID = $index"
  //   );
  //   print(res.toList());

  // }
  // Future<double> totalExpense(int index){
  //   double total = (await db.getExpense(index))[0]['Total'];
  //   print(total);
  //   set
  // }
}
