import 'package:flutter/material.dart';

typedef OnFilterChangedCallback = void Function(
    bool glutenFree, bool lactoseFree, bool vegetarian, bool vegan, bool halal);

void filtersDetailsWindow(
    BuildContext context,
    bool glutenFree,
    bool lactoseFree,
    bool vegetarian,
    bool vegan,
    bool halal,
    OnFilterChangedCallback onFilterChanged) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.amber,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    title: Text('Gluten free'),
                    subtitle: Text('Only include gluten-free meals.'),
                    trailing: Switch(
                      value: glutenFree,
                      onChanged: (isChecked) {
                        setState(() {
                          glutenFree = isChecked;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    title: Text('Lactose free'),
                    subtitle: Text('Only include lactose-free meals.'),
                    trailing: Switch(
                      value: lactoseFree,
                      onChanged: (isChecked) {
                        setState(() {
                          lactoseFree = isChecked;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    title: Text('Vegetarian dishes'),
                    subtitle: Text('Only include vegetarian meals.'),
                    trailing: Switch(
                      value: vegetarian,
                      onChanged: (isChecked) {
                        setState(() {
                          vegetarian = isChecked;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    title: Text('Vegan dishes'),
                    subtitle: Text('Only include vegan meals.'),
                    trailing: Switch(
                      value: vegan,
                      onChanged: (isChecked) {
                        setState(() {
                          vegan = isChecked;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    title: Text('Halal dishes'),
                    subtitle: Text('Only include halal meals.'),
                    trailing: Switch(
                      value: halal,
                      onChanged: (isChecked) {
                        setState(() {
                          halal = isChecked;
                        });
                      },
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceAround,
                    layoutBehavior: ButtonBarLayoutBehavior.padded,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onFilterChanged(glutenFree, lactoseFree, vegetarian,
                              vegan, halal);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 8.0),
                        ),
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 8.0),
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
