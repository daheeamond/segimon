import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(
        appBar:AppBar(
          title: Text("함께 한지 +7일째 ! \u{1f60e}"),
          
        ),
        body: Text('내용') ,
        bottomNavigationBar: BottomAppBar(child:Text('하단바')) ,
      )
    );

  }
}
