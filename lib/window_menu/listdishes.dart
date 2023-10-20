import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasty_and_easy/window_details_recept/Page_recept.dart';

class ListDishes extends StatefulWidget {
  final String dishKey;

  const ListDishes({Key? key, required this.dishKey}) : super(key: key);

  @override
  _ListDishesState createState() => _ListDishesState(dishKey);
}

class _ListDishesState extends State<ListDishes> {
  Query? dbRef;
  String dishKey;

  _ListDishesState(this.dishKey);

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.reference().child(dishKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dishKey),
        backgroundColor: Colors.lightGreen,
      ),
      body: StreamBuilder(
        stream: dbRef!.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map<String, dynamic> users = Map<String, dynamic>.from(
              (snapshot.data!.snapshot.value as Map).cast<String, dynamic>(),
            );

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
              ),
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final user1 = users.values.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListItem(
                    user1: user1,
                  ),
                );
              },
            );
          } else {
            return Text("Data is null");
          }
        },
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final Map user1;

  ListItem({required this.user1});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Page_recept(dishName: user1['name']),
          ),
        );
      },
      child: Container(
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
                user1['image_url'].toString(),
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Text(
                    user1['name'] != null ? user1['name'] : '',
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
