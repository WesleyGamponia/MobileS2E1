import 'package:mobiles2e1/models/budgetDetail.dart';

import 'item_event.dart';

class SetItems extends ItemEvent{
  List<Item> itemList;
  SetItems(List<Item> items){
    itemList=items;
  }
}