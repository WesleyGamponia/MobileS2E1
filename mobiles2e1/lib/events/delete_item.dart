import 'item_event.dart';

class DeleteItem extends ItemEvent{
  int itemIndex;
  DeleteItem(int index){
    itemIndex=index;
  }
}