import 'budget_event.dart';

class DeleteCategory extends CategoryEvent{
  int categoryIndex;
  DeleteCategory(int index){
    categoryIndex=index;
  }
}