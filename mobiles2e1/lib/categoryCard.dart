import 'dart:math';

import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final String title;
  final String item;
  final double budget;
  final double expense;
  CategoryCard({this.title, this.item, this.budget, this.expense});
  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  TextEditingController text = TextEditingController(text: '');
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
                              Container(width:75,child: Text("Title: ")),
                              Container(
                                width: 275,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    hintText: 'Enter Text to Style',
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: text,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:20,right:20,bottom:20),
                          child: Row(
                            children: [
                              Container(width:75,child: Text("Budget: ")),
                              Container(
                                width: 275,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    hintText: 'Enter Text to Style',
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: text,
                                ),
                              ),
                            ],
                          ),
                        ),
                         Padding(
                          padding: const EdgeInsets.only(left:20,right:20,bottom:20),
                          child: Row(
                            children: [
                              Container(width:75,child: Text("Date: ")),
                              Container(
                                width: 275,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    hintText: 'Enter Text to Style',
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: text,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
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
                                child: Text('ADD'), onPressed: () {}),
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
        child: Column(
          children: [
            _percentage(widget.budget, widget.expense),
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int position) {
                  return Container(
                    height: 50,
                    child: Card(
                      margin: EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left:10),
                              child: Text(
                                widget.title,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right:10,top:5),
                            child: Column(children: [
                              Expanded(child: Text("6/9/420")),
                              Expanded(child: Text("\$420.69")),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.only(left: 15),
                  );
                },
              ),
            ),
          ],
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
            double percentage = value * 100;
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
