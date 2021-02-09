import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  final String title;

  ItemCard({this.title});

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text(widget.title),
         actions: <Widget>[
           IconButton(icon: Icon(Icons.delete), onPressed: null),
         ],
       ),
       body: Column(

       ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
       floatingActionButton: FloatingActionButton(
         onPressed: (){},
          child: Icon(Icons.edit),
          backgroundColor: Theme.of(context).primaryColor,
    )
    );
  }
}
