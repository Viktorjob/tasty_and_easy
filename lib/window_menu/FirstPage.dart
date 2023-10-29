import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tasty_and_easy/drawer_menu/menu.dart';
import 'package:tasty_and_easy/window_menu/home_window.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Query dbRef = FirebaseDatabase.instance.reference().child('listrecept');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SecondMenuDrawer(),
      appBar: AppBar(
        title: Text("Main page"),
        backgroundColor: Colors.lightGreen , // Здесь установите желаемый цвет для AppBar
      ),


      body: StreamBuilder(
        stream: dbRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map<String, dynamic> users = Map<String, dynamic>.from(
              (snapshot.data!.snapshot.value as Map).cast<String, dynamic>(),
            );

            return Padding(
              padding: EdgeInsets.only(top:50),
              child: Container(
                width: 500,
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = users.values.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: listItem(user: user),
                    );
                  },
                ),
              ),
            );
          } else {
            return Text("Data is null");
          }
        },
      ),
    );
  }

  Widget listItem({required Map user}) {
    return InkWell(
      onTap: () {

      },
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                user['image'].toString(),
                fit: BoxFit.cover,
              ),
              Container(
                height: 10,
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Text(
                    user['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
