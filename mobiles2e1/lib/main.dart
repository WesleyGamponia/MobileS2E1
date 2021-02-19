import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobiles2e1/Database.dart';
import 'package:mobiles2e1/bloc/item_bloc.dart';
import 'package:mobiles2e1/bloc/item_bloc_delegate.dart';
import 'package:mobiles2e1/events/new_category.dart';
import 'package:mobiles2e1/events/set_categories.dart';
import 'package:mobiles2e1/events/set_items.dart';
import 'bloc/budget_bloc.dart';
import 'bloc/budget_bloc_delegate.dart';
import 'categoryCard.dart';
import 'models/budgetDetail.dart';
import 'package:intl/intl.dart';

void main() {
  BlocSupervisor.delegate = CategoryBlocDelegate();
  BlocSupervisor.delegate = ItemBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return CategoryBloc();
          },
        ),
        BlocProvider(
          create: (context) {
            return ItemBloc();
          },
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          accentColor: Color.fromRGBO(255, 203, 164, 1),
          canvasColor: Color.fromRGBO(255, 203, 164, 1),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
      ),
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
  int catID = 1;
  int nd = 0;
  DateTime prev = DateTime.now();
  DateTime nxt = DateTime.now();
  DateTime pDate = null;
  String pHolder, nHolder = '';
  @override
  void initState() {
    super.initState();
    DBProvider.db.getCategory().then((categoryList) =>
        BlocProvider.of<CategoryBloc>(context)
            .add(SetCategories(categoryList)));

    DBProvider.db.getItem().then((itemList) =>
        BlocProvider.of<ItemBloc>(context).add(SetItems(itemList)));

    setState(() {
      pHolder = DateFormat.yMd().format(prev.add(Duration(days: _weekfDate())));
      nHolder = DateFormat.yMd().format(nxt.add(Duration(days: _weeklDate())));
    });
  }

  String _displayDate(int n) {
    String d = '';
    nd = 1;
    switch (n) {
      case 0:
        d = DateFormat.yMd().format(prev.add(Duration(days: _weekfDate())));
        break;
      case 1:
        d = DateFormat.yMd().format(nxt.add(Duration(days: _weeklDate())));
        break;
      case 2:
        d = DateFormat.yMd().format(prev.add(Duration(days: _weekfDate() - 7)));
        prev = prev.add(Duration(days: _weekfDate() - 6));
        pDate = prev;
        break;
      case 3:
        d = DateFormat.yMd().format(prev.add(Duration(days: _weeklDate())));
        nxt = prev.add(Duration(days: _weekfDate()));
        break;
      case 4:
        d = DateFormat.yMd().format(prev.add(Duration(days: _weekfDate() + 7)));
        prev = prev.add(Duration(days: _weekfDate() + 8));
        pDate = prev;
        break;
      case 5:
        d = DateFormat.yMd().format(prev.add(Duration(days: _weeklDate())));
        nxt = prev.add(Duration(days: _weekfDate()));
        break;
    }
    return d;
  }

  int _weekfDate() {
    int n = 0;
    switch (DateFormat('EEEE').format(DateTime.now())) {
      case 'Monday':
        return n = -1;
        break;
      case 'Tuesday':
        return n = -2;
        break;
      case 'Wednesday':
        return n = -3;
        break;
      case 'Thursday':
        return n = -4;
        break;
      case 'Friday':
        return n = -5;
        break;
      case 'Saturday':
        return n = -6;
        break;
    }
    return n;
  }

  int _weeklDate() {
    int n = 6;
    switch (DateFormat('EEEE').format(DateTime.now())) {
      case 'Monday':
        return n = 5;
        break;
      case 'Tuesday':
        return n = 4;
        break;
      case 'Wednesday':
        return n = 3;
        break;
      case 'Thursday':
        return n = 2;
        break;
      case 'Friday':
        return n = 1;
        break;
      case 'Saturday':
        return n = 0;
        break;
    }
    return n;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _sideMenu(),
      appBar: AppBar(
        title: Text('Budget Planning'),
        // leading: IconButton(icon: Icon(Icons.settings), onPressed: () {}),
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
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9,]')),
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
                                  Budget category = Budget(
                                    title: categoryName.text,
                                    amount: double.parse(categoryBudget.text),
                                    expense: 0,
                                  );
                                  DBProvider.db.insertCategory(category).then(
                                        (storedCategory) =>
                                            BlocProvider.of<CategoryBloc>(
                                                    context)
                                                .add(
                                          AddCategory(storedCategory),
                                        ),
                                      );
                                  categoryBudget.text = '';
                                  categoryName.text = '';
                                  Navigator.pop(context);
                                }),
                          ),
                        ),
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
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          pHolder = _displayDate(2);
                          nHolder = _displayDate(3);
                        });
                      },
                    ),
                    // Text(DateFormat.yMd().format(DateTime.now().add(Duration(days: _weekfDate())))+' - ' + DateFormat.yMd().format(DateTime.now().add(Duration(days: _weeklDate())))),
                    nd == 0
                        ? Text(_displayDate(0) + ' - ' + _displayDate(1))
                        : Text(pHolder + ' - ' + nHolder),
                    IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          setState(() {
                            pHolder = _displayDate(4);
                            nHolder = _displayDate(5);
                          });
                        }),
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
                        SizedBox(
                          height: 10.0,
                        ),
                        BarChart(
                          nHolder: nHolder,
                          pHolder: pHolder,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
                CategoryList(),
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

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700.0,
      child: BlocConsumer<CategoryBloc, List<Budget>>(
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
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.all(16),
            physics: NeverScrollableScrollPhysics(),
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryCard(
                      title: categoryList[index].title,
                      //category: categoryList[index],
                      listIndex: index,
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
                    title: Text('${categoryList[index].title}'),
                    trailing: Text(
                        '${categoryList[index].expense}/${categoryList[index].amount}'),
                  ),
                ),
              );
            },
          );
        },
        listener: (BuildContext context, categoryList) {
          return null;
        },
      ),
    );
  }
}

Widget _sideMenu() {
  return Container(
    width: 210,
    child: Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            color: Colors.deepOrange[300],
            child: DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://scontent.fceb2-2.fna.fbcdn.net/v/t1.0-9/69760176_2922133204468094_4536344075783110656_o.jpg?_nc_cat=110&ccb=3&_nc_sid=09cbfe&_nc_eui2=AeE6cBfRjR6wYnyKEb0cQ2uRUmtov9zYuHtSa2i_3Ni4e9upwpPiXfQJ1WO90kyoxg-cdikS23fWJgyMAwtBcucB&_nc_ohc=V6L9QWD1AzwAX-jKlBC&_nc_oc=AQk0ZzuI-kUaU1gt9V_tmSX-xW44yyAH4bX3XjV_fQJNnyS4TyHm0j5XUf48bfD83oc&_nc_ht=scontent.fceb2-2.fna&oh=04c2a0a74f7de036c0ef734281ebd87e&oe=60506521'),
                  ),
                  SizedBox(height: 5),
                  Text('Ryan Gil B. Garcia'),
                  Text('ryan.garcia.20@usjr.edu.ph'),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class BarChart extends StatelessWidget {
  final String pHolder;
  final String nHolder;
  BarChart({this.pHolder, this.nHolder});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemBloc, List<Item>>(
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
        return Container(
          child: ChartList(itemList, nHolder, pHolder),
        );
      },
      listener: (BuildContext context, categoryList) {
        return null;
      },
    );
  }
}

class ChartList extends StatelessWidget {
  final List<Item> itemList;
  final String nHolder;
  final String pHolder;
  ChartList(this.itemList, this.nHolder, this.pHolder);

  int _dayDate(String day) {
    int n = 0;
    switch (day) {
      case 'Monday':
        return n = 1;
        break;
      case 'Tuesday':
        return n = 2;
        break;
      case 'Wednesday':
        return n = 3;
        break;
      case 'Thursday':
        return n = 4;
        break;
      case 'Friday':
        return n = 5;
        break;
      case 'Saturday':
        return n = 6;
        break;
    }
    return n;
  }

  List<Map<String, Object>> get days {
    return List.generate(7, (index) {
      String day = DateFormat('EEEE').format(DateTime.now());
      DateTime week = DateTime.now().add(Duration(days: index - _dayDate(day)));
      double examm = 0.0;
      DateTime exdate;
      int id;
      for (int i = 0; i < itemList.length; i++) {
        exdate = DateFormat('yMd').parse(itemList[i].date);
        if (week.day == exdate.day &&
            week.month == exdate.month &&
            week.year == exdate.year) {
          examm += itemList[i].amount;
          id = itemList[i].id;
           print(itemList[i].date);
        }
      }
     
      return {'day': DateFormat.E().format(week), 'amount': examm, 'id': id};
    });
  }

  double get totalDaySpend {
    return days.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }
 
//  DateFormat.yMd().format(prev.add(Duration(days: _weeklDate())));
//         nxt = prev.add(Duration(days: _weekfDate()));
  @override
  Widget build(BuildContext context) {
    // DateTime nHold = nHolder
    // DateFormat.yMMMMd().format(picked);
    return Column(
      children: [
        Text(nHolder),
        Text(pHolder),
        //Text(itemList[1].date),
        Card(
          child: Row(
            children: days.map((index) {
              return Expanded(
                child: Column(
                  children: [
                    Chart(
                        day: index['day'],
                        amm: index['amount'],
                        percent: totalDaySpend == 0
                            ? 0.0
                            : (index['amount'] as double) / totalDaySpend

                        // percent: totalDaySpend == 0
                        //     ? 0.0
                        //     : ((DateFormat('dMy').parse(itemList[index['id']].date).isAfter(
                        //                         DateFormat('dMy')
                        //                             .parse(pHolder))) &&
                        //                 (DateFormat('dMy')
                        //                     .parse(itemList[index['id']].date)
                        //                     .isBefore(DateFormat('dMy')
                        //                         .parse(nHolder))) )
                        //         ? (index['amount'] as double) / totalDaySpend
                        //         : Container(),
                        ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class Chart extends StatelessWidget {
  final String day;
  final double amm;
  final double percent;
  Chart({this.day, this.amm, this.percent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          '₱$amm',
          style: TextStyle(
            fontSize: 10.0,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Container(
          height: 60.0,
          width: 10.0,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: FractionallySizedBox(
                  heightFactor: percent,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Text('$day'),
      ],
    );
  }
}
