import 'package:flutter/material.dart';

import 'budgetDetail.dart';

class Cards extends StatefulWidget {
  final List<Item> list;
  final Function date;
  Cards({this.list, this.date});

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700.0,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
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
                                        hintText: '${widget.list[index].title}',
                                      ),
                                      keyboardType: TextInputType.text,
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
                                    hintText: '${widget.list[index].amount}',
                                  ),
                                  keyboardType: TextInputType.number,
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
                                  Container(width: 50, child: Text("Date: ")),
                                  Container(
                                    width: 200,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(10.0),
                                          ),
                                        ),
                                        hintText: '${widget.list[index].date}',
                                      ),
                                      keyboardType: TextInputType.number,
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
                title: Text('${widget.list[index].title}'),
                subtitle: Text('${widget.list[index].date}'),
                trailing: Text('${widget.list[index].amount}'),
              ),
            ),
          );
        },
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.list.length,
      ),
    );
  }
}