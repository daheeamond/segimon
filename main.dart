import 'package:flutter/material.dart';
import 'package:todo_hive/task.dart';

final List<Task> _items = [];//task를 만든다-캐시에 저장되있으니까 앱을 끄면 없어짐-DB를 사용해야함

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample'; //const 변수가 클래스 수준에 있는 경우, static const 로 표시

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
      barrierDismissible: false, // user must tap button! //Dialog를 제외한 다른 화면 터치 x
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('습관 추가하기',style:TextStyle(fontFamily: "Galmuri11"),),
          content: TextField(
            autofocus: true,
            onSubmitted: (String text) {//submit 했을때 아이템을 생성해서 리스트에 넣어줌
              setState(() {
                _items.add(Task(title: text));
              });
              Navigator.of(context).pop();//넣어진 부분 디스플레이에 나타나도록
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
      body: ReorderableListView(//proxyDecoeator,onRecorder만 빼면 리스트뷰와 거의 흡사함
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        proxyDecorator: (Widget child, int index, Animation<double> animation) {//리스트를 길게 누르고 있으면 이동할 수 있는 상태가 됨
          return TaskTile(itemIndex: index, onDeleted: () {});//이동할 수 있는 상태가 되었을떄 아이템의 레이아웃
        },
        children: <Widget>[
          for (int index = 0; index < _items.length; index += 1)
            Padding(
              key: Key('$index'),
              padding: const EdgeInsets.all(8.0),
              child: TaskTile(//커스텀 위젯 참고
                itemIndex: index,
                onDeleted: () {
                  setState(() {
                    _items.removeAt(index);
                  });
                },
              ),
            )
        ],
        onReorder: (int oldIndex, int newIndex) {//이동시 변경하는 부분
          setState(() {
            if (oldIndex < newIndex) {//클릭하고 이동 후 놨을때 이 코드가 실행됨
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
          color: item.finished ? Colors.grey : evenItemColor,//완료하면 상자 색 변경
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
                  fontFamily: "Galmuri11",//글꼴적용
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
