import 'package:mobiles2e1/models/budgetDetail.dart';

import 'item_event.dart';

class AddItem extends ItemEvent{
  Item newItem;

  AddItem(Item item){
    newItem=item;
  }
}