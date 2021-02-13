
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobiles2e1/Database.dart';
import 'package:mobiles2e1/bloc/item_bloc.dart';
import 'package:mobiles2e1/bloc/item_bloc_delegate.dart';
import 'package:mobiles2e1/events/new_category.dart';
import 'package:mobiles2e1/events/set_categories.dart';
import 'bloc/budget_bloc.dart';
import 'bloc/budget_bloc_delegate.dart';
import 'categoryCard.dart';
import 'models/budgetDetail.dart';

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
  @override
  void initState() {
    super.initState();
    DBProvider.db.getCategory().then((categoryList) =>
        BlocProvider.of<CategoryBloc>(context)
            .add(SetCategories(categoryList)));
  }
  @override
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
                                            BlocProvider.of<CategoryBloc>(context)
                                                .add(
                                          AddCategory(storedCategory),
                                        ),
                                      );
                                  categoryBudget.text = '';
                                  categoryName.text = '';
                                  Navigator.pop(context);
                                }
                                ),
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
                    subtitle: Text('${categoryList[index].amount}'),
                    trailing: IconButton(
                        color: Colors.red,
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // BlocProvider.of<CategoryBloc>(context).add(
                          //   CategoryEvent.delCategory(index),
                          // );
                        }
                        //onPressed: () =>{} //delete(categoryList[index].id),
                        ),
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
