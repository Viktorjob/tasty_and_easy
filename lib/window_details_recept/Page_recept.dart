import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Page_recept extends StatefulWidget {
  final String dishName;
  final String SSS;

  const Page_recept({Key? key, required this.dishName, required this.SSS, required String dishtime}) : super(key: key);

  @override
  _Page_receptState createState() => _Page_receptState();
}

class _Page_receptState extends State<Page_recept> {
  Query? dbRef;
  bool isFavorite = false;
  int likesCount = 0;
  Map<String, dynamic>? data;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  bool showScrollIcon = true;
  List<String> likedKeys = [];
  String newLikeKey = "";

  @override
  void initState() {
    super.initState();

    dbRef = FirebaseDatabase.instance.reference().child('${widget.dishName}');
    loadLikedKeys();
    loadIsFavorite();
    loadLikesCount();
  }

  void loadIsFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool favorite = prefs.getBool('${widget.dishName}_$uid') ?? false;
    setState(() {
      isFavorite = favorite || (data != null && data!['is_favorite'] == true);
    });
  }

  void loadLikedKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> keys = prefs.getStringList('likedKeys') ?? [];
    setState(() {
      likedKeys = keys;
    });
  }

  void saveLikedKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('likedKeys', likedKeys);
  }

  void loadLikesCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    likesCount = prefs.getInt('${widget.dishName}_likes') ?? 0;

    DatabaseReference likesRef =
    FirebaseDatabase.instance.reference().child('${widget.SSS}/${widget.dishName}/number_of_likes');

    likesRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          likesCount = (event.snapshot.value as int?) ?? 0;
        });
      }
    });
  }

  void saveIsFavorite(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('${widget.dishName}_$uid', value);
  }

  void saveLikesCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('${widget.dishName}_likes', likesCount);

    DatabaseReference likesRef =
    FirebaseDatabase.instance.reference().child('${widget.SSS}/${widget.dishName}/number_of_likes');
    likesRef.set(likesCount);
  }


  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      likesCount += isFavorite ? 1 : -1;
      saveLikesCount();
    });
    saveIsFavorite(isFavorite);

    DatabaseReference likesRef =
    FirebaseDatabase.instance.reference().child('${widget.SSS}/${widget.dishName}/number_of_likes');
    likesRef.set(likesCount);

    DatabaseReference likeListRef =
    FirebaseDatabase.instance.reference().child('users').child(uid!).child('Like_list');

    if (isFavorite && data != null) {
      DatabaseReference newLikeRef = likeListRef.push();
      // Update the existing class-level variable, don't redeclare
      newLikeKey = newLikeRef.key!;

      newLikeRef.set({
        'name': widget.dishName,
        'image_url': data!['image_url'],
        'time': data!['time'],
        'like': likesCount,
      }).then((_) {
        print('Сгенерированный ключ для нового элемента: $newLikeKey');
      });
    } else {
      likeListRef.orderByChild('name').equalTo(widget.dishName).once().then((event) {
        final snapshot = event.snapshot;
        Map<dynamic, dynamic>? values = snapshot.value as Map?;
        if (values != null) {
          values.forEach((key, value) {
            likeListRef.child(key).remove();
          });
        }
      });
    }
    // Adding or removing the key from the list
    if (isFavorite) {
      likedKeys.add(newLikeKey);
    } else {
      likedKeys.remove(newLikeKey);
    }
    saveLikedKeys();
  }

    Widget _buildIngredientsBlock(Map<String, dynamic> data) {
    List<Widget> ingredientsWidgets = [];
      print(likedKeys);


    for (int i = 1; i <= 13; i++) {
      String ingredientKey = 'ingredient_$i';
      String quantityKey = 'quantity_$i';

      if (data[ingredientKey] != null && data[quantityKey] != null) {
        ingredientsWidgets.add(_buildIngredientRow(data, i));
      }
    }

    double maxImageHeight = 300;
    double imageBorderRadius = 30.0;
    double imagePadding = 15.0;

    return Padding(
      padding: EdgeInsets.all(imagePadding),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(imageBorderRadius),
              border: Border.all(
                color: Colors.amber, // Цвет линии
                width: 2.0, // Ширина линии
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(imageBorderRadius),
              child: Image.network(
                data!['image_url'].toString(),
                fit: BoxFit.cover,
                width: double.infinity,
                height: maxImageHeight,
              ),
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(imageBorderRadius),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...ingredientsWidgets,
                  ],
                ),
              ),
            ),
          ),
          if (showScrollIcon && ingredientsWidgets.length > 6)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showScrollIcon = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(imageBorderRadius),
                    color: Colors.black.withOpacity(0.5), // Цвет затемненного фона
                    // Добавьте другие свойства декорации по вашему усмотрению
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/swipe.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                ),


              ),
            ),
        ],
      ),
    );
  }



  Widget _buildIngredientRow(Map<String, dynamic> data, int i) {
    String ingredientKey = 'ingredient_$i';
    String quantityKey = 'quantity_$i';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            data[ingredientKey],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.amber,
              margin: EdgeInsets.symmetric(horizontal: 8.0),
            ),
          ),
          Text(
            data[quantityKey],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(Map<String, dynamic> data, String stepKey) {
    if (data[stepKey] != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(data[stepKey], style: TextStyle(color: Colors.white)),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B0E12),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            saveLikesCount();
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.dishName),
      ),
      body: StreamBuilder(
        stream: dbRef!.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            data = Map<String, dynamic>.from(
              (snapshot.data!.snapshot.value as Map).cast<String, dynamic>(),
            );
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        data!['image_url'].toString(),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          data!['time'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (uid != null) {
                              toggleFavorite();
                            }
                          },
                          child: Opacity(
                            opacity: uid != null ? 1.0 : 0.3,
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_outline,
                              color: isFavorite ? Colors.amber : Colors.grey,
                            ),
                          ),
                        ),
                        Text('Likes: $likesCount', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Ingredients:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _buildIngredientsBlock(data!),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Instructions:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _buildStep(data!, '1_step'),
                  _buildStep(data!, '2_step'),
                  _buildStep(data!, '3_step'),
                  _buildStep(data!, '4_step'),
                  _buildStep(data!, '5_step'),
                  _buildStep(data!, '6_step'),
                  _buildStep(data!, '7_step'),
                  _buildStep(data!, '8_step'),
                  _buildStep(data!, '9_step'),
                  _buildStep(data!, '10_step'),
                  _buildStep(data!, '11_step'),
                  _buildStep(data!, '12_step'),
                  _buildStep(data!, '13_step'),
                ],
              ),
            );
          } else {
            return Center(
              child: Text("Data is null"),
            );
          }
        },
      ),
    );
  }
}
