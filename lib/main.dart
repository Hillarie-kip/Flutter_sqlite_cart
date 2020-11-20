import 'package:flutter/material.dart';
import 'package:flutter_app/screens/home_page.dart';
import 'package:flutter_app/screens/note_list.dart';

import 'package:provider/provider.dart';

import 'models/cart_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => Cart(),
      child: MaterialApp(
        title: 'Flutter Food Ordering',
        showSemanticsDebugger: false,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NoteList(),
      ),
    );
  }
}
