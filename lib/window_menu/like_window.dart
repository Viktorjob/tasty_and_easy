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
      userLikeListRef =
          FirebaseDatabase.instance.reference().child('users').child(uid).child(
              'Like_list');
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
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
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
    String? category = user['name'];

    if (likedItems.contains(itemKey)) {
      return Container(); // Элемент уже добавлен, не отображаем его.
    }

    return InkWell(
      onTap: () {
        likedItems.add(itemKey);
        if (category != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Page_recept(dishName: category, SSS: ''),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Color(0xFF0B0E12),
          border: Border.all(
            color: Colors.amber,
            width: 2.0,
          ),
        ),
        child: ClipRRect( // Обернуть весь Container в ClipRRect
          borderRadius: BorderRadius.circular(20.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                user['image_url'].toString(),
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black, Colors.transparent],
                    ),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          user['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          deleteData(itemKey);
                          likedItems.remove(itemKey);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber,
                          ),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
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
