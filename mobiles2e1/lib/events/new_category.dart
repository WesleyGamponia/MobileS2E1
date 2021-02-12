import 'package:mobiles2e1/models/budgetDetail.dart';

import 'budget_event.dart';

class AddCategory extends CategoryEvent{
  Budget newCategory;

  AddCategory(Budget category){
    newCategory=category;
  }
}