import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

void Comments_window(BuildContext context, String dishId, String userName) {
  final DatabaseReference commentsRef = FirebaseDatabase.instance.reference().child('comments').child(dishId);

  TextEditingController commentController = TextEditingController();

  showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.5,
        maxChildSize: 1.0,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(height: 12),

                  Text(
                    "Commends",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Expanded(
                    child: StreamBuilder(
                      stream: commentsRef.onValue,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                          Map<dynamic, dynamic> commentsMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                          List commentsList = commentsMap.values.toList();

                          return ListView.builder(
                            controller: scrollController,
                            itemCount: commentsList.length,
                            itemBuilder: (context, index) {
                              final comment = commentsList[index];
                              return ListTile(
                                title: Text(comment['user']),
                                subtitle: Text(comment['comment']),
                                trailing: Text(comment['timestamp']),
                              );
                            },
                          );
                        } else {
                          return Center(child: Text("No commends"));
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 8),
                  TextField(

                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      border: OutlineInputBorder(),
                    ),
                    onTap: () {

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 1.0,
                          minChildSize: 0.5,
                          maxChildSize: 1.0,
                          builder: (context, scrollController) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 16,
                                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      "Commends",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: StreamBuilder(
                                        stream: commentsRef.onValue,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                                            Map<dynamic, dynamic> commentsMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                                            List commentsList = commentsMap.values.toList();

                                            return ListView.builder(
                                              controller: scrollController,
                                              itemCount: commentsList.length,
                                              itemBuilder: (context, index) {
                                                final comment = commentsList[index];
                                                return ListTile(
                                                  title: Text(comment['user']),
                                                  subtitle: Text(comment['comment']),
                                                  trailing: Text(comment['timestamp']),

                                                );

                                              },
                                            );
                                          } else {
                                            return Center(child: Text("No commedns"));
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    TextField(
                                      controller: commentController,
                                      decoration: InputDecoration(
                                        hintText: "Write a comment...",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () async {
                                        // Check if the user is logged in
                                        if (userName.isNotEmpty && commentController.text.isNotEmpty) {
                                          // Get the current time
                                          String timestamp = DateTime.now().toIso8601String();
                                          // Save the comment to Firebase
                                          await commentsRef.push().set({
                                            'user': userName,
                                            'comment': commentController.text,
                                            'timestamp': timestamp,
                                          });
                                          // Clear the input field
                                          commentController.clear();
                                        }
                                      },
                                      child: Text("Send"),
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),

                            );
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
