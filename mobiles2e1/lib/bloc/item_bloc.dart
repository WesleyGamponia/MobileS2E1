import 'package:mobiles2e1/events/event.dart';
import 'package:mobiles2e1/models/budgetDetail.dart';

import 'package:bloc/bloc.dart';

class ItemBloc extends Bloc<TrackerEvent, List<Item>> {
  @override
  List<Item> get initialState => List<Item>();
  @override
  Stream<List<Item>> mapEventToState(TrackerEvent event) async* {
    switch (event.eventType) {
      case EventType.addItem:
        List<Item> newState = List.from(state);
        if (event.item != null) {
          newState.add(event.item);
        }
        yield newState;
        break;
      case EventType.delItem:
        List<Item> newState = List.from(state);
        print(newState.length);
        newState.removeAt(event.itemIndex);
        yield newState;
        break;
      default:
        throw Exception('Event not found $event');
    }
  }
}