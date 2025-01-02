import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:tasty_and_easy/window_menu/home_window.dart';
import 'package:tasty_and_easy/window_details_recept/listdishes.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  Query dbRef = FirebaseDatabase.instance.reference().child('listrecept');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0B0E12) ,
      ),
      backgroundColor: Color(0xFF0B0E12),
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

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
              ),
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final user = users.values.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: listItem(user: user),
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

  Widget listItem({required Map user}) {

    String? category = user['name'];
    return InkWell(
      onTap: () {
        print('Tapped on $category');
        if (category != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ListDishes(dishKey: category),
            ),
          );
        }
      },

      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.amber,
            width: 2.0,
          ),
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
