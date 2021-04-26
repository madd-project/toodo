import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:toodo/main.dart';
import 'package:toodo/models/todo_model.dart';
import 'package:share/share.dart';
//import 'package:toodo/uis/addTodoBottomSheet.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:toodo/uis/more_options_lists.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'addTodoBottomSheet.dart';

class TodoCard extends StatefulWidget {
  const TodoCard({
    Key key,
  }) : super(key: key);

  @override
  _TodoCardState createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  //bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<TodoModel>(todoBoxname).listenable(),
        builder: (context, Box<TodoModel> box, _) {
          List<int> keys = box.keys.cast<int>().toList();
          if (todoBox.isEmpty) {
            return Center(
              child: Text(
                'No Data Available',
                style: TextStyle(color: Colors.black26),
              ),
            );
          } else {
            return ListView.separated(
                itemCount: box.length,
                shrinkWrap: true,
                separatorBuilder: (_, index) => Container(),
                itemBuilder: (_, index) {
                  final int key = keys[index];
                  final TodoModel todo = box.get(key);

                  return Card(
                    color: Colors.white,
                    elevation: 1.4,
                    child: Wrap(
                      children: [
                        ListTile(
                          onLongPress: () {
                            print("object");
                          },
                          leading: IconButton(
                              icon: Icon(CarbonIcons.checkbox),
                              onPressed: () {}),
                          title: Text('${todo.todoName}'),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(66.0, 0, 30, 0),
                        //   // child: Text(
                        //   //   'Greyhound d ',
                        //   //   style:
                        //   //       TextStyle(color: Colors.black.withOpacity(0.6)),
                        //   // ),
                        // ),
                        ButtonBar(
                          children: [
                            Text('${todo.todoRemainder.toString()}'),
                            Text(
                              "•",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              '${todo.todoEmoji}',
                              style: TextStyle(fontSize: 20),
                            ),
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: false,
                                  shape: RoundedRectangleBorder(
                                    // <-- for border radius
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                  ),
                                  builder: (context) {
                                    // Using Wrap makes the bottom sheet height the height of the content.
                                    // Otherwise, the height will be half the height of the screen.
                                    return Wrap(
                                      children: [
                                        FlatButton(
                                          onPressed: () {},
                                          child: ListTile(
                                            leading: Icon(CarbonIcons.edit),
                                            title: Text("Edit"),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            Share.share(
                                                'check out my website https://example.com',
                                                subject: 'Look what I made!');
                                          },
                                          child: ListTile(
                                            leading: Icon(CarbonIcons.share),
                                            title: Text("Share"),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () {},
                                          child: ListTile(
                                            leading: Icon(CarbonIcons.download),
                                            title: Text("Download"),
                                          ),
                                        ),
                                        Divider(),
                                        FlatButton(
                                          onPressed: () async {
                                            await box.deleteAt(index);
                                            Navigator.pop(context);
                                          },
                                          child: ListTile(
                                            leading: Icon(CarbonIcons.delete,
                                                color: Colors.redAccent),
                                            title: Text(
                                              "Delete",
                                              style: TextStyle(
                                                  color: Colors.redAccent),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(CarbonIcons.overflow_menu_vertical),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                });
          }
        });

//     return Card(
//       color: Colors.white,
//       child: Wrap(
//         children: [
//           ListTile(
//             leading:
//                 IconButton(icon: Icon(CarbonIcons.checkbox), onPressed: () {}),
//             title: Text("Ride the Cycle, wooo!"),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(66.0, 0, 30, 0),
//             child: Text(
//               'Greyhound divisively hello coldly wonderfully marginally far upon excluding. Greyhound divisively hello coldly wonderfully marginally far upon excluding, ',
//               style: TextStyle(color: Colors.black.withOpacity(0.6)),
//             ),
//           ),
//           ButtonBar(
//             children: [
//               Text("4 am"),
//               Text(
//                 "•",
//                 style: TextStyle(fontSize: 20),
//               ),
//               Text(
//                 "😃",
//                 style: TextStyle(fontSize: 20),
//               ),
//               IconButton(
//                 onPressed: () {
//                   listMoreOptions(context);
//                 },
//                 icon: Icon(CarbonIcons.overflow_menu_vertical),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
  }
}
