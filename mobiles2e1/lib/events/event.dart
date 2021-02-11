
import 'package:mobiles2e1/models/budgetDetail.dart';

enum EventType {addCategory,delCategory, addItem, delItem}

class TrackerEvent {
  Budget category;
  Item item;

  int catIndex;
  int itemIndex;
  EventType eventType;

  TrackerEvent.addCategory(Budget category){
    this.eventType = EventType.addCategory;
    this.category = category;
  }
  TrackerEvent.delCategory(int index){
    this.eventType = EventType.delCategory;
    this.catIndex = index;
  }
  TrackerEvent.addItem(Item category){
    this.eventType = EventType.addItem;
    this.item = item;
  }
  TrackerEvent.delItem(int index){
    this.eventType = EventType.delItem;
    this.itemIndex = index;
  }

}