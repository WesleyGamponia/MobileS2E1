import 'package:mobiles2e1/models/budgetDetail.dart';

enum EventType { addCategory, delCategory, addItem, delItem }

class CategoryEvent {
  Budget category;
  int catIndex;
  EventType eventType;


  CategoryEvent.addCategory(Budget category) {
    this.eventType = EventType.addCategory;
    this.category = category;
  }
  CategoryEvent.delCategory(int index) {
    this.eventType = EventType.delCategory;
    this.catIndex = index;
  }
}

class ItemEvent {
  Item item;
  int itemIndex;
  EventType eventType;

  ItemEvent.addItem(Item item) {
    this.eventType = EventType.addItem;
    this.item = item;
  }
  ItemEvent.delItem(int index) {
    this.eventType = EventType.delItem;
    this.itemIndex = index;
  }
}

abstract class TrackerEvent{}