import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tasty_and_easy/country_dishes/dishes.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  ScrollController _scrollController = ScrollController();
  Query dbRef = FirebaseDatabase.instance.reference().child('Country');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF0B0E12),
    body: Container(
    decoration: BoxDecoration(
    /*image: DecorationImage(
    image: AssetImage('assets/ttt.jpg'), // Укажите путь к вашей картинке
    fit: BoxFit.cover,
    ),*/
    ),child: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              // Set background color to transparent
              elevation: 0,
              // Remove shadow
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return FlexibleSpaceBar(
                    background: Image.asset(
                      'assets/appbar_new.jpg',
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 2, // Adjust the height of the golden line
                color: Colors.amber, // Set the color to golden
              ),
            ),
          ];
        },
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

              return Padding(
                padding: EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    Text(
                      "Traditional Dishes",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 500,
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: users.length,
                        itemBuilder: (BuildContext context, int index) {
                          final user = users.values.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: listItem(user: user),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Text("Data is null");
            }
          },
        ),
    ),
    ),
    );
  }

  Widget listItem({required Map user}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => country_dish(),
          ),
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.amber, // Задайте цвет золотой линии
            width: 2.0, // Задайте толщину золотой линии
          ),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
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
                user['image_url'].toString(),
                fit: BoxFit.cover,
              ),
              Container(
                height: 10,
                color: Colors.black.withOpacity(0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}