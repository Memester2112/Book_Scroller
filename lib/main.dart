import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ('Listings:'),
      color: Colors.indigo.shade300,
      debugShowCheckedModeBanner: false,
      home: Listings(),
    );
  }
}

class User {
  final int userId;
  final int id;
  final String title;
  final String body;

  User({this.userId, this.id, this.title, this.body});

//constructor
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body']);
  }
}

Future<User> fetchUser() async {
  //async is used for future libraries
  //it waits till it gets a response, meanwhile the other processes continue
  //when it does finally have a value it updates

  final response =
      await http.get('https://jsonplaceholder.typicode.com/posts/5');
//The http.get() method returns a Future that contains a Response

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('Status code = 200\n');
    return User.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Status code : ERROR\n');
    throw Exception('Failed to load User data');
  }
}

class Listings extends StatefulWidget {
  @override
  _ListingsState createState() => _ListingsState();
}

class _ListingsState extends State<Listings> {
  final cart = Set<String>(); //contains list of books already in the cart
  final int numberOfBooks = 10;
  final collection = Set<String>();

  void checkCart() {
    setState(() {});
  }

  Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  void page01() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Internet Data'),
            ),
            body: FutureBuilder<User>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print('Data found\n');
                  return Column(
                    children: <Widget>[
                      Text('User Id :' + snapshot.data.userId.toString()),
                      Text('Id :' + snapshot.data.id.toString()),
                      Text('Title :' + snapshot.data.title),
                      Text('Body :' + snapshot.data.body),
                    ],
                  );
                } else if (snapshot.hasError) {
                  print('Error detected\n');
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                print('Spinning\n');
                return Center(child: CircularProgressIndicator());
              },
            ),
          );
        },
      ),
    );
  }

  Widget browse() {
    for (int x = 0; x < numberOfBooks; x++) collection.add('0' + x.toString());

    return Scaffold(
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: numberOfBooks * 2,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, i) {
            if (i.isOdd)
              return Divider(
                color: Colors.blue,
              );
            int r = i ~/ 2;
            return buildTile(r);
          }),
      floatingActionButton: CircleAvatar(
        child: IconButton(
          icon: Icon(
            Icons.book,
            color: Colors.yellow,
            size: 30.0,
          ),
          onPressed: page01,
        ),
        radius: 25.0,
        backgroundColor: Colors.blueAccent.shade200,
      ),
    );
  }

  Widget buildTile(int bookNumber) {
    final boolVal = cart.contains(collection.elementAt(bookNumber));
    return ListTile(
      leading: Image.asset(
          'book_images/' + collection.elementAt(bookNumber) + '.jpg'),
      title: Text('Book ' + collection.elementAt(bookNumber)),
      trailing: Icon(
        (Icons.add),
        color: boolVal ? Colors.red : Colors.grey,
      ),
      onTap: () {
        setState(() {
          if (boolVal) {
            cart.remove(collection.elementAt(bookNumber));
          } else {
            cart.add(collection.elementAt(bookNumber));
          }
        });
      },
    );
  }

  void openCart() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Center(child: Text('Your Cart')),
            ),
            body: ListView(
              padding: EdgeInsets.all(8.0),
              children: [
                for (String n in cart)
                  Column(
                    children: [
                      ListTile(
                        leading: Image.asset('book_images/' + n + '.jpg'),
                        title: Text('Book ' + n),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Listings:')),
        backgroundColor: Colors.blueAccent.shade200,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            iconSize: 40.0,
            color: Colors.yellow.shade400,
            hoverColor: Colors.indigo,
            onPressed: openCart,
          ),
        ],
      ),
      body: SafeArea(
        child: browse(),
      ),
    );
  }
}
