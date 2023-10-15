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
  Map<String, bool> likedItems = {};

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
                final itemName = user1['name'];
                final isLiked = likedItems[itemName] ?? false;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListItem(
                    user1: user1,
                    isLiked: isLiked,
                    toggleLike: (value) {
                      setState(() {
                        likedItems[itemName] = value;
                      });
                    },
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

class ListItem extends StatefulWidget {
  final Map user1;
  final bool isLiked;
  final ValueChanged<bool> toggleLike;

  ListItem({required this.user1, required this.isLiked, required this.toggleLike});

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool isHeartActive = false;

  @override
  void initState() {
    super.initState();
    isHeartActive = widget.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    Color heartColor = isHeartActive ? Colors.yellow : Colors.white;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Page_recept(dishName: widget.user1['name']),
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
                widget.user1['image_url'].toString(),
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Text(
                    widget.user1['name'] != null ? widget.user1['name'] : '',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 145,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isHeartActive = !isHeartActive;
                    });

                    widget.toggleLike(isHeartActive);

                    if (isHeartActive) {
                      DatabaseReference likeListRef =
                      FirebaseDatabase.instance.reference().child('Like_list');
                      likeListRef.push().set({
                        'name': widget.user1['name'],
                        'image_url': widget.user1['image_url'],
                      });
                    }
                  },
                  child: Icon(
                    Icons.favorite,
                    size: 28,
                    color: heartColor,
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
