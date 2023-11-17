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
      userLikeListRef = FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(uid)
          .child('Like_list');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Save recipes"),
        ),
        backgroundColor: Color(0xFF0B0E12),
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
        backgroundColor: Color(0xFF0B0E12),
      ),
      backgroundColor: Color(0xFF0B0E12),
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

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 20.0,
              ),
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final key = users.keys.elementAt(index);
                final user = users.values.elementAt(index);
                return listItem(user: user, itemKey: key);
              },
            );
          } else {
            return Center(
                child: Text("You haven't added your favorite dish yet"));
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
    String? dishName = user['name'];

    if (likedItems.contains(itemKey)) {
      return Container(); // Element is already added, don't display it.
    }

    return InkWell(
        onTap: () {
          likedItems.add(itemKey);
          if (dishName != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Page_recept(dishName: dishName, SSS: ''),
              ),
            );
          }
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 200,
              width: 220,
              padding: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(0xFF0B0E12),
                border: Border.all(
                  color: Colors.amber,
                  width: 2.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  user['image_url'].toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ), // Image with dark overlay
            // Dark overlay at the bottom
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black],
                          //stops: [0.1, 50],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          dishName ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 30.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color(0xFF0B0E12),
                    border: Border.all(
                      color: Colors.amber,
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          deleteData(itemKey);
                          likedItems.remove(itemKey);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 50.0),
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.bookmark_border,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ) // Container for the image
        );
  }
}
