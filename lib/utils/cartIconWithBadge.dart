import 'package:flutter/material.dart';
import 'package:flutter_app/constants/Constants.dart';
import 'package:flutter_app/screens/CartList.dart';

class cartIconWithBadge extends StatelessWidget {
  int counter ;
  cartIconWithBadge({Key key, this.counter}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.shopping_cart,
            size: 30,
            color: AppColors.colorAccent,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CartList()));
            // Scaffold.of(context).openEndDrawer();
          },
        ),
        counter != 0
            ? Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 13,
                    minHeight: 13,
                  ),
                  child: Text(
                    '$counter',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
