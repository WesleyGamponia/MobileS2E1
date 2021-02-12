import 'package:mobiles2e1/models/budgetDetail.dart';

import 'budget_event.dart';

class UpdateCategory extends CategoryEvent {
  Budget newCategory;
  int categoryIndex;

  UpdateCategory(int index, Budget category) {
    newCategory = category;
    categoryIndex = index;
  }
}
