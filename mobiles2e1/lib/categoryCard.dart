import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobiles2e1/Database.dart';
import 'package:mobiles2e1/bloc/budget_bloc.dart';
import 'package:mobiles2e1/bloc/item_bloc.dart';
import 'package:mobiles2e1/events/new_item.dart';
import 'package:mobiles2e1/events/set_items.dart';
import 'package:mobiles2e1/events/update_category.dart';
import 'cardItem.dart';
import 'models/budgetDetail.dart';
import 'Database.dart';

class CategoryCard extends StatefulWidget {
  final String title;
  final int listIndex;
  CategoryCard({this.title, this.listIndex});
  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  

  TextEditingController itemTitle = TextEditingController(text: '');
  TextEditingController itemDate = TextEditingController(text: '');
  TextEditingController itemCost = TextEditingController(text: '');
  String day;
  int itemID = 1;

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2022),
    );
    if (picked != null)
      setState(() {
        itemDate.text = DateFormat.yMMMMd().format(picked);
        day = DateFormat('EEEE').format(picked);
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, List<Budget>>(
      buildWhen: (List<Budget> previous, List<Budget> current) {
        return true;
      },
      listenWhen: (List<Budget> previous, List<Budget> current) {
        if (current.length > previous.length)
          return true;
        else
          return false;
      },
      builder: (context, categoryList) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      color: Color.fromRGBO(255, 203, 164, 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Container(width: 50, child: Text("Title: ")),
                                Container(
                                  width: 200,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                      ),
                                      hintText: 'Enter Expense Title',
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: itemTitle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Row(
                              children: [
                                Container(width: 50, child: Text("Cost: ")),
                                Container(
                                  width: 200,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                      ),
                                      hintText: 'Enter Expense Cost',
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9,]')),
                                    ],
                                    controller: itemCost,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Row(
                              children: [
                                Container(width: 50, child: Text("Date: ")),
                                Container(
                                  width: 150,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                      ),
                                      hintText: 'No Choosen Date',
                                    ),
                                    enabled: false,
                                    controller: itemDate,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.calendar_today),
                                      onPressed: () => _selectDate(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 250.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              child: FlatButton(
                                child: Text('ADD'),
                                onPressed: () {
                                  Item item = Item(
                                    title: itemTitle.text, //name
                                    amount:
                                        double.parse(itemCost.text), //expense
                                    categoryID: categoryList[widget.listIndex]
                                        .id, //catID
                                    date: itemDate.text, //date
                                  );
                                  DBProvider.db.insertItem(item).then(
                                        (storedItem) =>
                                            BlocProvider.of<ItemBloc>(context)
                                                .add(
                                          AddItem(storedItem),
                                        ),
                                      );
                                  Budget category1 = Budget(
                                    id: categoryList[widget.listIndex].id,
                                    amount:
                                        categoryList[widget.listIndex].amount,
                                    expense:
                                        categoryList[widget.listIndex].expense +
                                            double.parse(itemCost.text),
                                    title: categoryList[widget.listIndex].title,
                                  );
                                  DBProvider.db.updateCategory(category1).then(
                                      (storedCategory) =>
                                          BlocProvider.of<CategoryBloc>(context)
                                              .add(UpdateCategory(
                                                  widget.listIndex,
                                                  category1)));

                                  itemTitle.text = "";
                                  itemCost.text = "";
                                  itemDate.text = "";
                                  Navigator.pop(context);
                                  if (categoryList[widget.listIndex].expense >
                                      categoryList[widget.listIndex].amount) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Error'),
                                            content:
                                                Text('You are way over budget'),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Ok'))
                                            ],
                                          );
                                        });
                                  } else if (categoryList[widget.listIndex]
                                          .expense >
                                      categoryList[widget.listIndex].amount *
                                          .9) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Warning'),
                                          content:
                                              Text('Budget is almost out '),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Ok'))
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _percentage(categoryList[widget.listIndex].amount,
                      categoryList[widget.listIndex].expense),
                  Cards(
                    catID: categoryList[widget.listIndex].id,
                    listIndex: widget.listIndex,
                    category: categoryList[widget.listIndex],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (BuildContext context, categoryList) {
        return null;
      },
    );
  }

  Widget _percentage(
    double budget,
    double expense,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        height: 200,
        width: 200,
        child: TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: (expense / budget)),
          duration: Duration(seconds: 1),
          builder: (context, value, child) {
            double percentage = expense;
            return Stack(
              children: [
                RotationTransition(
                  turns: AlwaysStoppedAnimation(-90 / 360),
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return SweepGradient(
                        stops: [value, value],
                        startAngle: 0.0,
                        endAngle: 3.14 * 2,
                        center: Alignment.center,
                        colors: [Colors.deepOrange, Colors.transparent],
                      ).createShader(rect);
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(255, 203, 164, 1),
                    ),
                    child: Center(
                      child: Text(
                        percentage.toStringAsFixed(1) + '/' + budget.toString(),
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class PercentageCircle extends StatefulWidget {
  final double expense;
  final double budget;
  PercentageCircle({this.budget, this.expense});

  @override
  _PercentageCircleState createState() => _PercentageCircleState();
}

class _PercentageCircleState extends State<PercentageCircle> {
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: (widget.expense / widget.budget)),
        duration: Duration(seconds: 1),
        builder: (context, value, child) {
          double percentage = value * 100;
          return Container(
            height: 200,
            width: 200,
            child: Stack(
              children: [
                RotationTransition(
                  turns: AlwaysStoppedAnimation(-90 / 360),
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return SweepGradient(
                        stops: [value, value],
                        startAngle: 0.0,
                        endAngle: 3.14 * 2,
                        center: Alignment.center,
                        colors: [Colors.blue, Colors.transparent],
                      ).createShader(rect);
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(255, 203, 164, 1),
                    ),
                    child: Center(
                      child: Text(
                        percentage.toStringAsFixed(1) +
                            '/' +
                            widget.budget.toString(),
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
