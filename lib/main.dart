
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Welcome(),
    ));



class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int currentIndexPage;
  List<Widget> pages = <Widget>[
    FirstSlide(),
    Slide(textContent: "Two"),
    Slide(textContent: "Three"),
    Slide(textContent: "Four"),
    Slide(textContent: "Five"),
    Slide(textContent: "Six"),
    Slide(textContent: "Seven"),
    EighthSlide()
  ];

  @override
  void initState() {
    currentIndexPage = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        PageView(
          children: pages,
          onPageChanged: (value) {
            setState(() => currentIndexPage = value);
          },
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.7,
          child: Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.38),
            child: Align(
              alignment: Alignment.center,
              child: new DotsIndicator(
                dotsCount: pages.length,
                position: currentIndexPage,
                decorator: DotsDecorator(
                    color: Colors.grey, activeColor: Colors.black),
              ),
            ),
          ),
        )
      ],
    ));
  }
}

class EighthSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.redAccent),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: OutlineButton(
            textColor: Colors.white,
            onPressed: () {
              print("Clicked button");
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
            child: Text("Skip"),
          ),
        ),
      ),
    );
  }
}

class FirstSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(text: "Welcome to "),
              TextSpan(
                  text: "Clear", style: TextStyle(fontWeight: FontWeight.bold))
            ], style: TextStyle(fontSize: 32.0, color: Colors.black))),
            RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: "Tap or Swipe ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "to begin")
            ], style: TextStyle(fontSize: 24.0, color: Colors.black)))
          ],
        ),
      ),
    );
  }
}

class Slide extends StatelessWidget {
  final String textContent;

  Slide({Key key, @required this.textContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.redAccent),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(child: Text(textContent)),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State createState() {
    return HomeState();
  }
}

class HomeState extends State {
  List<Todo> todoList = [];

  @override
  void initState() {
    todoList = [
      Todo(position:0,textContent: "Buy Groceries"),
      Todo(position:1,textContent: "Buy Tablets"),
      Todo(position:2,textContent: "Water Plants"),
      Todo(position:3,textContent: "Remove Weeds"),
      Todo(position:4,textContent: "Go to movie"),
      Todo(position:5,textContent: "Fix almairah"),
      Todo(position:6,textContent: "Service Car"),
      Todo(position:7,textContent: "Get Documents"),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget getTodoItem(Todo todo) {
      return Dismissible(
          key: Key(todo.position.toString()),
          onDismissed: (direction) {
            switch (direction) {
              case DismissDirection.endToStart:
                setState(() {
                  todoList.remove(todo);
                });
                break;
              case DismissDirection.startToEnd:
                setState(() {
                  todo.isCompleted = true;
                  todo.position = todoList.last.position + 1;
                  todoList.remove(todo);
                  todoList.add(todo);
                });
                break;
              default:
                break;
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient:LinearGradient(colors: [Colors.red, Colors.redAccent])),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                todo.textContent,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Text("Personal List"),
      ),
      body: Stack(children: <Widget>[
        ReorderableListView(
          onReorder: (oldIndex, newIndex) {
            if (oldIndex == newIndex) return;
            setState(() {
              Todo item = todoList[oldIndex];
              todoList.removeAt(oldIndex);
              Todo previousItem = todoList[newIndex-1];
              if(previousItem.isCompleted){
                item.isCompleted = true;
              }
              todoList.insert(newIndex, item);
            });
          },
          children: <Widget>[for (Todo todo in todoList) getTodoItem(todo)],
        ),
        Positioned(
            right: 16.0,
            bottom: MediaQuery.of(context).size.height * .1,
            child: FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    todoList.insert(0, Todo(textContent: "New Task"));
                  });
                },
                label: Text("New Task")))
      ]),
    );
  }
}

class Todo {
  String textContent;
  var position;
  var isCompleted = false;

  Todo({this.position,this.textContent});
}
