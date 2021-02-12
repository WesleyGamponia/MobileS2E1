
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobiles2e1/Database.dart';
import 'package:mobiles2e1/bloc/item_bloc.dart';
import 'package:mobiles2e1/events/new_item.dart';
import 'package:mobiles2e1/events/set_items.dart';
import 'cardItem.dart';
import 'models/budgetDetail.dart';
import 'Database.dart';
class CategoryCard extends StatefulWidget {
  final String title;
  final double budget;
  final int catID;
  CategoryCard({this.title, this.budget, this.catID});
  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  
  @override
  void initState() {
    super.initState();
    DBProvider.db.getItem().then((itemList) =>
        BlocProvider.of<ItemBloc>(context)
            .add(SetItems(itemList)));
            
  }


  TextEditingController itemTitle = TextEditingController(text: '');
  TextEditingController itemDate = TextEditingController(text: '');
  TextEditingController itemCost = TextEditingController(text: '');
  String day;
  int itemID = 1;
  double expense=0;
 
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        itemDate.text = DateFormat.yMMMMd().format(picked);
        day = DateFormat('EEEE').format(picked);
      });
  }
  @override
  void getExpense(double a){
    List<Item> items = List<Item>();
    setState(() {
      expense+=a;
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
                                amount: double.parse(itemCost.text), //expense
                                categoryID: widget.catID, //catID
                                date: itemDate.text,//date
                              );
                              DBProvider.db.insertItem(item).then(
                                    (storedItem) =>
                                        BlocProvider.of<ItemBloc>(context).add(
                                      AddItem(storedItem),
                                    ),
                                  );
                              //_add(
                              //     itemTitle.text,
                              //     double.parse(itemCost.text),
                              //     itemDate.text);
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
                                      content: Text('Budget is almost out '),
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
              _percentage(widget.budget, expense),
              Cards(
                getExpense:getExpense,
                catID: widget.catID,
                  ),
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

// class Cards extends StatelessWidget {
//   final List<Item> list;
//   final Function date;
//   Cards({this.list, this.date});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 700.0,
//       child: ListView.builder(
//         itemBuilder: (context, index) {
//           return InkWell(
//             onTap: () {
//               showModalBottomSheet(
//                   context: context,
//                   builder: (context) => Container(
//                         color: Color.fromRGBO(255, 203, 164, 1),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: Row(
//                                 children: [
//                                   Container(width: 50, child: Text("Title: ")),
//                                   Container(
//                                     width: 200,
//                                     child: TextField(
//                                       decoration: InputDecoration(
//                                         border: OutlineInputBorder(
//                                           borderRadius: const BorderRadius.all(
//                                             const Radius.circular(10.0),
//                                           ),
//                                         ),
//                                         hintText: '${list[index].title}',
//                                       ),
//                                       keyboardType: TextInputType.text,
//                                       // controller: itemTitle,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20, right: 20, bottom: 20),
//                           child: Row(
//                             children: [
//                               Container(width: 50, child: Text("Cost: ")),
//                               Container(
//                                 width: 200,
//                                 child: TextField(
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderRadius: const BorderRadius.all(
//                                         const Radius.circular(10.0),
//                                       ),
//                                     ),
//                                     hintText: '${list[index].amount}',
//                                   ),
//                                   keyboardType: TextInputType.number,
//                                   // controller: itemCost,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                   left: 20, right: 20, bottom: 20),
//                               child: Row(
//                                 children: [
//                                   Container(width: 50, child: Text("Date: ")),
//                                   Container(
//                                     width: 200,
//                                     child: TextField(
//                                       decoration: InputDecoration(
//                                         border: OutlineInputBorder(
//                                           borderRadius: const BorderRadius.all(
//                                             const Radius.circular(10.0),
//                                           ),
//                                         ),
//                                         hintText: '${list[index].date}',
//                                       ),
//                                       keyboardType: TextInputType.number,
//                                       //controller: itemDate,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ));
//             },
//             // => Navigator.push(
//             //     context,
//             //     MaterialPageRoute(
//             //         builder: (context) => ItemCard(
//             //               title: list[index].title,
//             //             ))),
//             child: Card(
//               color: Colors.deepOrange[300],
//               margin: EdgeInsets.symmetric(
//                 horizontal: 20.0,
//                 vertical: 8.0,
//               ),
//               elevation: 10,
//               child: ListTile(
//                 title: Text('${list[index].title}'),
//                 subtitle: Text('${list[index].date}'),
//                 trailing: Text('${list[index].amount}'),
//               ),
//             ),
//           );
//         },
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         itemCount: list.length,
//       ),
//     );
//   }
// }
