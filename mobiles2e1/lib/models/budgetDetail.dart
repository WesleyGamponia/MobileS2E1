
import 'package:mobiles2e1/Database.dart';

class Budget {//category
   String title;//name
   double amount;//budget
   int id;
   double expense;
  Budget({this.title, this.amount,this.id,this.expense});

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      DBProvider.CATEGORY_NAME: title,
      DBProvider.CATEGORY_BUDGET: amount,
      DBProvider.CATEGORY_EXPENSE: expense,
    };
    if(id!=null){
      map[DBProvider.CATEGORY_ID]=id;
    }
    return map;
  }

  Budget.fromMap(Map<String,dynamic>map){
    id= map[DBProvider.CATEGORY_ID];
    title= map[DBProvider.CATEGORY_NAME];
    amount= map[DBProvider.CATEGORY_BUDGET];
    expense = map[DBProvider.CATEGORY_EXPENSE];
  }
}

class Item { 
  String title; //name
  String date; 
  double amount; //expense
  int categoryID;
  int id; 
  Item({this.title, this.date, this.amount,this.categoryID,this.id}); 

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      DBProvider.ITEM_NAME: title,
      DBProvider.ITEM_DATE: date,
      DBProvider.ITEM_EXPENSE: amount,
      DBProvider.ITEM_CATEGORY: categoryID,
      
    };
    if(id!=null){
      map[DBProvider.ITEM_ID]=id;
    }
    return map;
  }

  Item.fromMap(Map<String,dynamic>map){
    id= map[DBProvider.ITEM_ID];
    title= map[DBProvider.ITEM_NAME];
    amount= map[DBProvider.ITEM_EXPENSE];
    categoryID= map[DBProvider.ITEM_CATEGORY];
    date= map[DBProvider.ITEM_DATE];
  }
}