import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tasty_and_easy/window_details_recept/Page_recept.dart';
import 'package:tasty_and_easy/window_details_recept/filtrs_window.dart';
import 'package:tasty_and_easy/window_menu/home_window.dart';


class ListDishes extends StatefulWidget {
  final String dishKey;

  const ListDishes({Key? key, required this.dishKey}) : super(key: key);

  @override
  _ListDishesState createState() => _ListDishesState(dishKey);
}

class _ListDishesState extends State<ListDishes> {
  Query? dbRef;
  String dishKey;
  bool glutenFree = false;
  bool lactoseFree = false;
  bool vegetarian = false;
  bool vegan = false;
  bool halal = false;
  String SSS = '';
  _ListDishesState(this.dishKey) {
    SSS = dishKey; // Присвойте значение dishKey переменной SSS
  }
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              filtersDetailsWindow(
                context,
                glutenFree,
                lactoseFree,
                vegetarian,
                vegan,
                halal,
                    (gluten, lactose, veg, vegan, halal_dish) {
                  setState(() {
                    glutenFree = gluten;
                    lactoseFree = lactose;
                    vegetarian = veg;
                    halal = halal_dish;
                    this.vegan = vegan;
                  });
                },
              );
            },
          ),
        ],
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

            final filteredDishes = users.values.where((dish) {
              return (!glutenFree || dish['Gluten'] == glutenFree) &&
                  (!lactoseFree || dish['Lactose'] == lactoseFree) &&
                  (!vegetarian || dish['Vegetarian'] == vegetarian) &&
                  (!vegan || dish['Vegan'] == vegan) &&
                  (!halal || dish['Halal'] == halal);
            }).toList();

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
                childAspectRatio: 5 / 3, // You can adjust this ratio as needed
              ),
              itemCount: filteredDishes.length,
              itemBuilder: (BuildContext context, int index) {
                final user1 = filteredDishes[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListItem(
                    user1: user1,
                    SSS: SSS,
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
  final String SSS;
  ListItem({required this.user1,required this.SSS});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Page_recept(dishName: user1['name'], SSS: SSS),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20), // Задаем общий радиус для всех углов
          child: Container(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(2, 2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  user1['image_url'].toString(),
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.6),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user1['name'] != null ? user1['name'] : '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.bookmark_border, // Иконка сердца
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(width: 10), // Расстояние между иконкой и текстом
                                Text(
                                  '${user1['number_of_likes']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.access_time, // Иконка сердца
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '${user1['time']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


