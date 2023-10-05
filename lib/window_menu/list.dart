import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildRecipeGrid("listrecept"),

          ],
        ),
      ),
    );
  }

  Widget _buildRecipeGrid(String collectionName) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data!.docs;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 30.0,
              mainAxisSpacing: 20.0,
            ),
            shrinkWrap: true,
            primary: false,
            itemCount: snap.length,
            itemBuilder: (BuildContext context, int index) {
              var doc = snap[index];
              var imageURL = doc['image'];

              return InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/listdishes');
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
                  child: Stack(
                    children: [
                      Image.network(
                        imageURL,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black.withOpacity(0.6),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
