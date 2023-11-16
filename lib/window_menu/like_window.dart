import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tasty_and_easy/window_details_recept/Page_recept.dart';

class LikeWindow extends StatefulWidget {
  const LikeWindow({Key? key}) : super(key: key);

  @override
  _LikeWindowState createState() => _LikeWindowState();
}

class _LikeWindowState extends State<LikeWindow> {
  late DatabaseReference userLikeListRef;
  Set<String> likedItems = Set();

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      userLikeListRef = FirebaseDatabase.instance.reference().child('users').child(uid).child('Like_list');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Favorite dishes"),

        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("You need to be logged in to view your favorite dishes."),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite dishes"),
        backgroundColor: Colors.lightGreen,
      ),
      body: StreamBuilder(
        stream: userLikeListRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map<String, dynamic> users = Map<String, dynamic>.from(
              (snapshot.data!.snapshot.value as Map).cast<String, dynamic>(),
            );

            return ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final key = users.keys.elementAt(index);
                final user = users.values.elementAt(index);
                return listItem(user: user, itemKey: key);
              },
            );
          } else {
            return Center(child: Text("You haven't added your favorite dish yet"));
          }
        },
      ),
    );
  }

  void deleteData(String key) {
    userLikeListRef.child(key).remove().then((_) {
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
        if (category != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Page_recept(dishName: category, SSS: '',),
            ),
          );
        }
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(8),
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
                likedItems.remove(itemKey);
              },
            ),
          ],
        ),
      ),
    );
  }
}
