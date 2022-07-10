import 'package:flutter/material.dart';
import 'package:todo_hive/task.dart';

final List<Task> _items = [];

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('습관 추가하기',style:TextStyle(fontFamily: "Galmuri11"),),
          content: TextField(
            autofocus: true,
            onSubmitted: (String text) {
              setState(() {
                _items.add(Task(title: text));
              });
              Navigator.of(context).pop();
            },
            textInputAction: TextInputAction.send,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xff6A7BA2),
        title: const Text("습관달성 +7일째 ! \u{1f60e}",
          style: TextStyle(color: Color(0xffFFDFDE),fontFamily: "Galmuri11",fontSize: 20.0),),
        leading: const Text('7월 4일 (수)', style: TextStyle(color: Color(0xffFFDFDE),fontFamily: "Galmuri11",fontSize: 13.0,)),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showMyDialog();
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
        backgroundColor:const Color(0xff6A7BA2),
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        proxyDecorator: (Widget child, int index, Animation<double> animation) {
          return TaskTile(itemIndex: index, onDeleted: () {});
        },
        children: <Widget>[
          for (int index = 0; index < _items.length; index += 1)
            Padding(
              key: Key('$index'),
              padding: const EdgeInsets.all(8.0),
              child: TaskTile(
                itemIndex: index,
                onDeleted: () {
                  setState(() {
                    _items.removeAt(index);
                  });
                },
              ),
            )
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final Task item = _items.removeAt(oldIndex);
            _items.insert(newIndex, item);
          });
        },
      ),
    );
  }
}

class TaskTile extends StatefulWidget {
  const TaskTile({
    Key? key,
    required this.itemIndex,
    required this.onDeleted,
  }) : super(key: key);

  final int itemIndex;
  final Function onDeleted;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    const Color evenItemColor = Color(0xff8AAAE5);
    final Task item = _items[widget.itemIndex];

    return Material(
      child: AnimatedContainer(
        constraints: const BoxConstraints(minHeight: 60),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: item.finished ? Colors.grey : evenItemColor,
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        child: Row(
          children: [
            Checkbox(
              key: widget.key,
              value: item.finished,
              onChanged: (checked) {
                setState(() {
                  item.finished = checked ?? false;
                });
              },
            ),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontFamily: "Galmuri11",
                  fontSize: 20,
                  color: Colors.white,
                  decoration: item.finished
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,

                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () => widget.onDeleted(),
            )
          ],
        ),
      ),
    );
  }
}
