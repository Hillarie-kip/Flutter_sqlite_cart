import 'package:flutter/material.dart';
import 'package:flutter_app/screens/note_list.dart';

import 'package:provider/provider.dart';


void main() => runApp((MaterialApp(
debugShowCheckedModeBanner: false,
theme: ThemeData(fontFamily: 'Roboto', hintColor: Color(0xFFd0cece)),
home: CartList(),
)
),
);


