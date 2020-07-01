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

  Widget browse() {
    for (int x = 0; x < numberOfBooks; x++) collection.add('0' + x.toString());

    return ListView.builder(
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
        });
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
