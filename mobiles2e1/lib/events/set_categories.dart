import 'package:mobiles2e1/models/budgetDetail.dart';

import 'budget_event.dart';

class SetCategories extends CategoryEvent{
  List<Budget> categoryList;
  SetCategories(List<Budget> categories){
    categoryList=categories;
  }
}