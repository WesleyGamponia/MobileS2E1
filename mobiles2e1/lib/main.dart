import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'budgetDetail.dart';
import 'categoryCard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Color.fromRGBO(255, 203, 164, 1),
        canvasColor: Color.fromRGBO(255, 203, 164, 1),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController categoryName = TextEditingController(text: '');
  TextEditingController categoryBudget = TextEditingController(text: '');
  List<Budget> _categoryList = [];
  int catID = 1;

  void _add(String bTitle, int bAmount) {
    final Budget add = Budget(
      title: bTitle,
      amount: bAmount,
      id: catID,
    );
    setState(() {
      _categoryList.add(add);
      catID++;
    });
  }

  void delete(int id){
    setState(() {
      _categoryList.removeWhere((index) {
        return index.id == id;
      });
    });
  }
  @override
  
  // List delete(List<Budget> list){
  //   List<Budget> list2;

  //   for (var i = 0; i < list.length; i++) {
  //     if (list[i].id!=list2[i].id){
  //       list2[i] = list[i];
  //     }
  //   }
  //   return  list2;
  // }

  // void delete(String search){
  //   setState(() {
  //     List<Budget> list = _categoryList;

  //     for (var i = 0; i < _categoryList.length; i++) {
  //     if(list[i].title!=search){
  //       list.removeAt(i);
  //     }
  //   }
  //   _categoryList = list;
  //   });
    
  // }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Planning'),
        leading: IconButton(icon: Icon(Icons.settings), onPressed: () {}),
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
                              Text("Title: "),
                              Container(
                                width: 200,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    hintText: 'Enter Category Title',
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: categoryName,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              Text("Budget: "),
                              Container(
                                width: 183,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    hintText: 'Enter Budget',
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: categoryBudget,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                                  ],
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
                                child: Text('ADD'),
                                onPressed: () {
                                  _add(categoryName.text,
                                      int.parse(categoryBudget.text));
                                  categoryName.text = "";
                                  categoryBudget.text = "";
                                  Navigator.pop(context);
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
                    Text("02/02/21 - 02/09/21"),
                    IconButton(
                        icon: Icon(Icons.arrow_forward), onPressed: () {}),
                  ],
                ),
                Container(
                  child: Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0,
                    ),
                    elevation: 15.0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text('Sun'),
                              Text('Mon'),
                              Text('Tue'),
                              Text('Wed'),
                              Text('Thur'),
                              Text('Fri'),
                              Text('Sat'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              for (var i = 0; i < 7; i++) Percent(size: .5),
                            ]),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            for (var i = 0; i < 7; i++) Text('1'),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Cards(list: _categoryList,delete: delete,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Percent extends StatelessWidget {
  final double size;
  Percent({this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      width: 8.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(),
      ),
      child: FractionallySizedBox(
        heightFactor: size,
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.deepOrange[300],
        ),
      ),
    );
  }
}

class Cards extends StatelessWidget {
  final List<Budget> list;
  final Function delete;
  Cards({this.list,this.delete});
  
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
                // builder: (context)=>_category("Food", "Pizza", 100, 56)
                builder: (context) => CategoryCard(
                  title: list[index].title,
                  item: "Pizza",
                  budget: list[index].amount.toDouble(),
                  expense: 69.0,
                ),
              ),
            ),
            child: Card(
              color: Colors.deepOrange[300],
              margin: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              elevation: 10,
              child: ListTile(
                title: Text('${list[index].title}'),
                subtitle: Text('${list[index].amount}'),
                trailing: IconButton(
                  color: Colors.red,
                  icon: Icon(Icons.delete),
                  onPressed: () => delete(list[index].id),
                ),
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
