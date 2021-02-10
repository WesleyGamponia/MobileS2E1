import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobiles2e1/itemCard.dart';

import 'budgetDetail.dart';

class CategoryCard extends StatefulWidget {
  final String title;
  final double budget;
  CategoryCard({this.title, this.budget});
  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  TextEditingController itemTitle = TextEditingController(text: '');
  TextEditingController itemDate = TextEditingController(text: '');
  TextEditingController itemCost = TextEditingController(text: '');
  String day;
  List<Item> _itemList = [];
  int itemID = 1;
  double expense = 0;
  DateTime _date;

  void _add(String iTitle, double iAmount, String iDate) {
    final Item add = Item(
      title: iTitle,
      amount: iAmount,
      date: iDate,
      id: itemID,
    );
    setState(() {
      expense += iAmount;
      _itemList.add(add);
    });
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      setState(() {
        _date = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                              Container(width: 75, child: Text("Title: ")),
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
                              Container(width: 75, child: Text("Cost: ")),
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
                              Container(width: 75, child: Text("Date: ")),
                              Expanded(
                        child: Text(
                          _date == null
                              ? 'No Date Chosen'
                              : DateFormat.yMMMMd().format(_date),
                        ),
                      ),
                              FlatButton(
                                  onPressed: _presentDatePicker,
                                  child: Text('Add Date'))
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
                                  _add(
                                      itemTitle.text,
                                      double.parse(itemCost.text),
                                      itemDate.text);
                                  itemTitle.text = "";
                                  itemCost.text = "";
                                  itemDate.text = "";
                                  Navigator.pop(context);
                                  if (expense > widget.budget) {
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
                                  } else if (expense > widget.budget * .9) {
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
                                        });
                                  }
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _percentage(widget.budget, expense),
              Cards(list: _itemList),
            ],
          ),
        ),
      ),
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

class Cards extends StatelessWidget {
  final List<Item> list;
  Cards({this.list});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700.0,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemCard(
                          title: list[index].title,
                        ))),
            child: Card(
              color: Colors.deepOrange[300],
              margin: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              elevation: 10,
              child: ListTile(
                title: Text('${list[index].title}'),
                subtitle: Text('${list[index].date}'),
                trailing: Text('${list[index].amount}'),
              ),
            ),
          );
        },
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: list.length,
      ),
    );
  }
}
