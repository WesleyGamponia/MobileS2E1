import 'package:mobiles2e1/events/delete_item.dart';
import 'package:mobiles2e1/events/item_event.dart';
import 'package:mobiles2e1/events/new_item.dart';
import 'package:mobiles2e1/events/set_items.dart';
import 'package:mobiles2e1/events/update_item.dart';
import 'package:mobiles2e1/models/budgetDetail.dart';

import 'package:bloc/bloc.dart';

class ItemBloc extends Bloc<ItemEvent, List<Item>> {
  @override
  List<Item> get initialState => List<Item>();
  @override
  Stream<List<Item>> mapEventToState(ItemEvent event) async* {
    if (event is SetItems) {
      yield event.itemList;
    } else if (event is AddItem) {
      List<Item> newState = List.from(state);
      if (event.newItem != null) {
        newState.add(event.newItem);
      }
      yield newState;
    } else if (event is DeleteItem) {
      List<Item> newState = List.from(state);
      newState.removeAt(event.itemIndex);
      yield newState;
    } else if (event is UpdateItem) {
      List<Item> newState = List.from(state);
      newState[event.itemIndex] = event.newItem;
      yield newState;
    }
    
  }
}