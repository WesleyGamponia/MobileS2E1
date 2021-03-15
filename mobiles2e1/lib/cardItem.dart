import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobiles2e1/bloc/budget_bloc.dart';
import 'package:mobiles2e1/bloc/item_bloc.dart';
import 'package:mobiles2e1/events/delete_item.dart';
import 'package:mobiles2e1/events/update_category.dart';
import 'package:mobiles2e1/events/update_item.dart';
import 'package:mobiles2e1/models/budgetDetail.dart';
import 'package:mobiles2e1/Database.dart';

class Cards extends StatefulWidget {
  final int listIndex;
  final int catID;
  final Budget category;
  Cards({this.catID, this.listIndex, this.category});

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
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
              TextEditingController itemTitle =
                  TextEditingController(text: '${itemList[index].title}');
              TextEditingController itemCost =
                  TextEditingController(text: '${itemList[index].amount}');
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
                                                ),
                                                keyboardType:
                                                    TextInputType.text,
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
                                                ),
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r"[0-9.]")),
                                                ],
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                  decimal: true,
                                                  signed: false,
                                                ),
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
                                                enabled: false,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(10.0),
                                              ),
                                            ),
                                            child: FlatButton(
                                              //UPDATE
                                              child: Text('Change'),
                                              onPressed: () {
                                                if (int.parse(itemCost.text) ==
                                                    0) {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text('Error'),
                                                        content: Text(
                                                            'Please check your inputed cost'),
                                                        actions: [
                                                          FlatButton(
                                                            child: Text('Ok'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  double orgExpense =
                                                      itemList[index]
                                                          .amount; //old value
                                                  Item item = Item(
                                                    amount: double.parse(
                                                        itemCost.text),
                                                    title: itemTitle.text,
                                                    date: itemList[index].date,
                                                    categoryID: itemList[index]
                                                        .categoryID,
                                                    id: itemList[index].id,
                                                  );
                                                  DBProvider.db
                                                      .update(item)
                                                      .then((storedItem) =>
                                                          BlocProvider.of<
                                                                      ItemBloc>(
                                                                  context)
                                                              .add(UpdateItem(
                                                                  index,
                                                                  item)));
                                                  Budget category1 = Budget(
                                                      id: widget.category.id,
                                                      amount: widget
                                                          .category.amount,
                                                      expense: widget.category
                                                              .expense +
                                                          double.parse(
                                                              itemCost.text) -
                                                          orgExpense,
                                                      title: widget
                                                          .category.title);
                                                  DBProvider.db
                                                      .updateCategory(category1)
                                                      .then((storedCategory) =>
                                                          BlocProvider.of<
                                                                      CategoryBloc>(
                                                                  context)
                                                              .add(UpdateCategory(
                                                                  widget
                                                                      .listIndex,
                                                                  category1)));
                                                  itemTitle.text = "";
                                                  itemCost.text = "";
                                                  Navigator.pop(context);
                                                }
                                              },
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(10.0),
                                              ),
                                            ),
                                            child: IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  Budget category1 = Budget(
                                                      id: widget.category.id,
                                                      amount: widget
                                                          .category.amount,
                                                      expense: widget.category
                                                              .expense -
                                                          itemList[index]
                                                              .amount,
                                                      title: widget
                                                          .category.title);
                                                  DBProvider.db
                                                      .updateCategory(category1)
                                                      .then((storedCategory) =>
                                                          BlocProvider.of<
                                                                      CategoryBloc>(
                                                                  context)
                                                              .add(UpdateCategory(
                                                                  widget
                                                                      .listIndex,
                                                                  category1)));
                                                  DBProvider.db
                                                      .delete(
                                                          itemList[index].id)
                                                      .then(
                                                        (_) => BlocProvider.of<
                                                                    ItemBloc>(
                                                                context)
                                                            .add(
                                                          DeleteItem(index),
                                                        ),
                                                      );
                                                  Navigator.pop(context);
                                                }),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                      },
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
          return null;
        },
      ),
    );
  }
}
