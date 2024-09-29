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
    backgroundColor: Colors.transparent, // Делаем фон прозрачным
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5, // Начальный размер (половина экрана)
        minChildSize: 0.5, // Минимальный размер (половина экрана)
        maxChildSize: 1.0, // Максимальный размер (весь экран)
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white, // Цвет нижней части
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)), // Закругление верхних углов
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16, // Отступ снизу равен высоте клавиатуры
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
                    "Комментарии",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Отображение комментариев из Firebase
                  Expanded(
                    child: StreamBuilder(
                      stream: commentsRef.onValue,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                          Map<dynamic, dynamic> commentsMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                          List commentsList = commentsMap.values.toList();

                          return ListView.builder(
                            controller: scrollController, // Используем переданный ScrollController
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
                          return Center(child: Text("Нет комментариев"));
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 8),
                  TextField(

                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "Напишите комментарий...",
                      border: OutlineInputBorder(),
                    ),
                    onTap: () {
                      // Когда пользователь нажимает на текстовое поле, раскройте на полный экран
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 1.0, // Полный экран
                          minChildSize: 0.5, // Минимальный размер
                          maxChildSize: 1.0, // Максимальный размер
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
                                      "Комментарии",
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
                                            return Center(child: Text("Нет комментариев"));
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    TextField(
                                      controller: commentController,
                                      decoration: InputDecoration(
                                        hintText: "Напишите комментарий...",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () async {
                                        // Проверяем, залогинен ли пользователь
                                        if (userName.isNotEmpty && commentController.text.isNotEmpty) {
                                          // Получаем текущее время
                                          String timestamp = DateTime.now().toIso8601String();

                                          // Сохраняем комментарий в Firebase
                                          await commentsRef.push().set({
                                            'user': userName,
                                            'comment': commentController.text,
                                            'timestamp': timestamp,
                                          });

                                          // Очищаем поле ввода
                                          commentController.clear();
                                        }
                                      },
                                      child: Text("Отправить"),
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
