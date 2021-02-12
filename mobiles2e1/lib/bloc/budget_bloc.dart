import 'package:mobiles2e1/events/delete_category.dart';
import 'package:mobiles2e1/events/new_category.dart';
import 'package:mobiles2e1/events/set_categories.dart';
import 'package:mobiles2e1/events/update_category.dart';
import 'package:mobiles2e1/models/budgetDetail.dart';
import 'package:mobiles2e1/events/budget_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, List<Budget>> {
  @override
  List<Budget> get initialState => List<Budget>();
  @override
  Stream<List<Budget>> mapEventToState(CategoryEvent event) async* {
    if (event is SetCategories) {
      yield event.categoryList;
    } else if (event is AddCategory) {
      List<Budget> newState = List.from(state);
      if (event.newCategory != null) {
        newState.add(event.newCategory);
      }
      yield newState;
    } else if (event is DeleteCategory) {
      List<Budget> newState = List.from(state);
      newState.removeAt(event.categoryIndex);
      yield newState;
    } else if (event is UpdateCategory) {
      List<Budget> newState = List.from(state);
      newState[event.categoryIndex] = event.newCategory;
      yield newState;
    }
    //   switch (event is) {
    //     case EventType.addCategory:
    //       List<Budget> newState = List.from(state);
    //       if (event.category != null) {
    //         newState.add(event.category);
    //       }
    //       yield newState;
    //       break;
    //     case EventType.delCategory:
    //       List<Budget> newState = List.from(state);
    //       print(newState.length);
    //       newState.removeAt(event.catIndex);
    //       yield newState;
    //       break;
    //     default:
    //       throw Exception('Event not found $event');
    //   }
    // }
  }
}
