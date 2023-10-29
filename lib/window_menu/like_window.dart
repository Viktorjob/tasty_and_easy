import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tasty_and_easy/drawer_menu/menu.dart';
import 'package:tasty_and_easy/window_menu/home_window.dart';
import 'package:tasty_and_easy/window_details_recept/listdishes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeWindow extends StatefulWidget {
  const LikeWindow({Key? key}) : super(key: key);

  @override
  _LikeWindowState createState() => _LikeWindowState();
}

class _LikeWindowState extends State<LikeWindow> {
  Query dbRef = FirebaseDatabase.instance.reference().child('Like_list');
  Set<String> likedItems = Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SecondMenuDrawer(),
      appBar: AppBar(
        title: Text("Main page3"),
        backgroundColor: Colors.lightGreen,
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

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final key = users.keys.elementAt(index);
                final user = users.values.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: listItem(user: user, itemKey: key),
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

  void deleteData(String key) {
    DatabaseReference reference = FirebaseDatabase.instance.reference().child(
        'Like_list');

    reference.child(key).remove().then((_) {
      print('Data deleted successfully');
    }).catchError((error) {
      print('Failed to delete data: $error');
    });
  }

  Widget listItem({required Map user, required String itemKey}) {
    String? category = user['name'];

    if (likedItems.contains(itemKey)) {
      return Container(); // Элемент уже добавлен, не отображаем его.
    }

    return InkWell(
      onTap: () {
        likedItems.add(itemKey); // Добавляем элемент в множество при нажатии.
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
        child: Row(
          children: [
            Container(
              width: 100,
              child: Image.network(
                user['image_url'].toString(),
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  user['name'],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteData(itemKey);
                likedItems.remove(itemKey); // Удаляем элемент из множества.
              },
            ),
          ],
        ),
      ),
    );
  }
}
