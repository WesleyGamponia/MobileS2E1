import 'package:mobiles2e1/models/budgetDetail.dart';

import 'item_event.dart';

class UpdateItem extends ItemEvent {
  Item newItem;
  int itemIndex;

  UpdateItem(int index, Item item) {
    newItem = item;
    itemIndex = index;
  }
}
