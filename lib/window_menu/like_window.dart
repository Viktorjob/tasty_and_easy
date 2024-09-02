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
          backgroundColor: Color(0xFF0B0E12),
        ),
        backgroundColor: Color(0xFF0B0E12),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("You need to be logged in to view your favorite dishes.",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),)
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite dishes",style: TextStyle(
          color: Colors.white) ),
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
                child: Text("You haven't added your favorite dish yet" ,style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),));
          }
        },
      ),
    );
  }

  void deleteData(String key) {
    userLikeListRef.child(key).remove().then((_) {
      print('Data deleted successfully');
      setState(() {
        likedItems.remove(key);
      });
    }).catchError((error) {
      print('Failed to delete data: $error');
    });
  }


  Widget listItem({required Map user, required String itemKey}) {
    String? dishName = user['name'];
    String? dishtime = user['time'];

    bool isLiked = likedItems.contains(itemKey);

    return InkWell(
      onTap: () {
        setState(() {
          if (!isLiked) {
            likedItems.add(itemKey);
          }
        });

        if (dishName != null || dishtime != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Page_recept(
                dishName: dishName ?? '',
                dishtime: dishtime ?? '',
                SSS: '',
              ),
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
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Черный контейнер с закругленными углами
              Container(
                height: 55,
                width: 220,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),

                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  dishName ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Контейнер с информацией, имеющий закругленные углы
              Container(
                height: 40.0,
                width: 220,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color(0xFF0B0E12),
                  border: Border.all(
                    color: Colors.amber,
                    width: 2.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        dishtime ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 24.0,
                    ),
                    SizedBox(width: 5),
                    Text(
                      user['like'].toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        deleteData(itemKey);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),


    );
  }

}