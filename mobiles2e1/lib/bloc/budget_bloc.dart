import 'package:mobiles2e1/events/event.dart';
import 'package:mobiles2e1/models/budgetDetail.dart';

import 'package:bloc/bloc.dart';

class CategoryBloc extends Bloc<TrackerEvent, List<Budget>> {
  @override
  List<Budget> get initialState => List<Budget>();
  @override
  Stream<List<Budget>> mapEventToState(TrackerEvent event) async* {
    switch (event.eventType) {
      case EventType.addCategory:
        List<Budget> newState = List.from(state);
        if (event.category != null) {
          newState.add(event.category);
        }
        yield newState;
        break;
      case EventType.delCategory:
        List<Budget> newState = List.from(state);
        print(newState.length);
        newState.removeAt(event.catIndex);
        yield newState;
        break;
      default:
        throw Exception('Event not found $event');
    }
  }
}