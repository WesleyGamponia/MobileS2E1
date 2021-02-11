
class Budget {//category
  final String title;//name
  final double amount;//budget
  // final int id;
  Budget({this.title, this.amount,});

  
}

class Item { 
  final String title; //name
  final String date; 
  final double amount; //expense
  //final int categoryID;
  //final int id; 
  Item({this.title, this.date, this.amount}); 
}