import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobiles2e1/bloc/item_bloc.dart';
import 'package:mobiles2e1/events/set_items.dart';
import 'package:mobiles2e1/models/budgetDetail.dart';
import 'package:mobiles2e1/Database.dart';

class Cards extends StatefulWidget {
  Function getExpense;
  final int catID;
  Cards({this.catID,this.getExpense});

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700.0,
      child: BlocConsumer<ItemBloc, List<Item>>(
        buildWhen: (List<Item> previous, List<Item> current) {
          return true;
        },
        listenWhen: (List<Item> previous, List<Item> current) {
          if (current.length > previous.length)
            return true;
          else
            return false;
        },
        builder: (context, itemList) {
          
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.all(16),
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              
              return (itemList[index].categoryID == widget.catID)
                  ? InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                                  color: Color.fromRGBO(255, 203, 164, 1),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 50,
                                                child: Text("Title: ")),
                                            Container(
                                              width: 200,
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      const Radius.circular(
                                                          10.0),
                                                    ),
                                                  ),
                                                  hintText:
                                                      '${itemList[index].title}',
                                                ),
                                                keyboardType:
                                                    TextInputType.text,
                                                // controller: itemTitle,
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
                                            Container(
                                                width: 50,
                                                child: Text("Cost: ")),
                                            Container(
                                              width: 200,
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      const Radius.circular(
                                                          10.0),
                                                    ),
                                                  ),
                                                  hintText:
                                                      '${itemList[index].amount}',
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                // controller: itemCost,
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
                                            Container(
                                                width: 50,
                                                child: Text("Date: ")),
                                            Container(
                                              width: 200,
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      const Radius.circular(
                                                          10.0),
                                                    ),
                                                  ),
                                                  hintText:
                                                      '${itemList[index].date}',
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                //controller: itemDate,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                      },
                      // => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ItemCard(
                      //               title: list[index].title,
                      //             ))),
                      child: Card(
                        color: Colors.deepOrange[300],
                        margin: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8.0,
                        ),
                        elevation: 10,
                        child: ListTile(
                          title: Text('${itemList[index].title}'),
                          subtitle: Text('${itemList[index].date}'),
                          trailing: Text('${itemList[index].amount}'),
                        ),
                      ),
                    )
                  : Container();
            },
            physics: NeverScrollableScrollPhysics(),
          );
        },
        listener: (BuildContext context, itemList) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("added"),
          ));
        },
      ),
    );
  }
}
