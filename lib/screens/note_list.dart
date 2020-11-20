import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants/colors.dart';
import 'package:flutter_app/models/Cart.dart';
import 'package:flutter_app/utils/database_helper.dart';
import 'package:flutter_app/screens/note_detail.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';


class NoteList extends StatefulWidget {

	@override
  State<StatefulWidget> createState() {

    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {

	DatabaseHelper databaseHelper = DatabaseHelper();
	List<Cart> noteList;
	int count = 0;


	var now = DateTime.now();
	get weekDay => DateFormat('EEEE').format(now);
	get day => DateFormat('dd').format(now);
	get month => DateFormat('MMMM').format(now);


	ScrollController scrollController = ScrollController();
	@override
  Widget build(BuildContext context) {
		if (noteList == null) {
			noteList = List<Cart>();
			updateListView();
		}





		return Scaffold(

			body: getNoteListView(),

	    floatingActionButton: FloatingActionButton(
		    onPressed: () {
		      debugPrint('FAB clicked');
		      navigateToDetail(Cart('123456', 1,'Hilla Restaurant', 2,'Pizza','12345',2000,1,''), 'Add Note');
		    },

		    tooltip: 'Add Note',

		    child: Icon(Icons.add),

	    ),
    );
  }

  ListView getNoteListView() {

		TextStyle titleStyle = Theme.of(context).textTheme.subhead;

		return ListView.builder(


			itemCount: count,
			itemBuilder: (BuildContext context, int position) {

				return Card(
					color: Colors.white,
					elevation: 2.0,
					child:
					Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						crossAxisAlignment: CrossAxisAlignment.start,
						children: <Widget>[
							Flexible(
								flex: 3,
								fit: FlexFit.tight,
								child: ClipRRect(
									borderRadius: BorderRadius.all(Radius.circular(16)),
									child: Image.network(noteList[position].productImage),
								),
							),
							Flexible(
								flex: 5,
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.center,
									mainAxisAlignment: MainAxisAlignment.spaceBetween,
									children: <Widget>[
										Container(
											height: 50,
											child: Text(
												noteList[position].productName,
												style: titleStyle,
												textAlign: TextAlign.center,
											),
										),
										Row(
											mainAxisSize: MainAxisSize.max,
											crossAxisAlignment: CrossAxisAlignment.center,
											mainAxisAlignment: MainAxisAlignment.center,
											children: <Widget>[
												InkWell(
													onTap: () => _RemoveQuantity(context,noteList[position],noteList[position].quantity--),
													child: Icon(Icons.remove_circle),
												),
												Padding(
													padding: EdgeInsets.symmetric(horizontal: 16.0),
													child: Text('${noteList[position].quantity.toString()}', style: titleStyle),
												),
												InkWell(
													onTap: () => _AddQuantity(context,noteList[position],noteList[position].quantity++),
													child: Icon(Icons.add_circle),
												),
											],
										)
									],
								),
							),
							Flexible(
								flex: 2,
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.end,
									mainAxisAlignment: MainAxisAlignment.spaceBetween,
									children: <Widget>[
										Container(
											height: 40,
											width: 70,
											child: Text(
												'\$ ${noteList[position].quantity*noteList[position].productPrice}',
												style: titleStyle,
												textAlign: TextAlign.end,
											),
										),
										Card(
											shape: roundedRectangle,
											color: mainColor,
											child: InkWell(
											onTap: () =>  _delete(context,noteList[position]),
												customBorder: roundedRectangle,
												child: Icon(Icons.close),
											),
										)
									],
								),
							),
						],


					),
				);
			},
		);
  }

	Widget buildPriceInfo(Cart cart) {
		final titleStyle2 = TextStyle(fontSize: 18, color: Colors.black45);
		double total = 0;

			total += cart.productPrice * cart.quantity;

		return Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: <Widget>[
				Text('Total:', style: titleStyle2),
				Text('\$ ${total.toStringAsFixed(2)}'),
			],
		);
	}

	Widget checkoutButton(cart, context) {
		final titleStyle1 = TextStyle(fontSize: 16);
		return Container(
			margin: EdgeInsets.only(top: 16, bottom: 64),
			child: Center(
				child: RaisedButton(
					child: Text('Checkout', style: titleStyle1),
					onPressed: () {},
					padding: EdgeInsets.symmetric(horizontal: 64, vertical: 12),
					color: mainColor,
					shape: StadiumBorder(),
				),
			),
		);
	}

	Widget buildCartItemList( Cart cart) {
		var titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
		return Container(
			margin: EdgeInsets.only(bottom: 16),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: <Widget>[
					Flexible(
						flex: 3,
						fit: FlexFit.tight,
						child: ClipRRect(
							borderRadius: BorderRadius.all(Radius.circular(16)),
							child: Image.network(cart.productImage),
						),
					),
					Flexible(
						flex: 5,
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.center,
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: <Widget>[
								Container(
									height: 50,
									child: Text(
										cart.productName,
										style: titleStyle,
										textAlign: TextAlign.center,
									),
								),
								Row(
									mainAxisSize: MainAxisSize.max,
									crossAxisAlignment: CrossAxisAlignment.center,
									mainAxisAlignment: MainAxisAlignment.center,
									children: <Widget>[
										InkWell(
										//	onTap: () => cart.removeItem(cartModel),
											child: Icon(Icons.remove_circle),
										),
										Padding(
											padding: EdgeInsets.symmetric(horizontal: 16.0),
											child: Text('${cart.quantity}', style: titleStyle),
										),
										InkWell(
											//onTap: () => cart.increaseItem(cartModel),
											child: Icon(Icons.add_circle),
										),
									],
								)
							],
						),
					),
					Flexible(
						flex: 2,
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.end,
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: <Widget>[
								Container(
									height: 40,
									width: 70,
									child: Text(
										'\$ ${cart.productPrice}',
										style: titleStyle,
										textAlign: TextAlign.end,
									),
								),
								Card(
									shape: roundedRectangle,
									color: mainColor,
									child: InkWell(
									//	onTap: () => cart.removeAllInList(cartModel.food),
										customBorder: roundedRectangle,
										child: Icon(Icons.close),
									),
								)
							],
						),
					),
				],
			),
		);
	}



	void _delete(BuildContext context, Cart note) async {

		int result = await databaseHelper.deleteNote(note.id);
		if (result != 0) {
			_showSnackBar(context, 'Note Deleted Successfully');
			updateListView();
		}
	}




	void _AddQuantity(BuildContext context, Cart note,int quantity) async {

		int result = await databaseHelper.updateQuantityNote(note.id,note.quantity++);
		if (result != 0) {
			_showSnackBar(context, note.productName+' added to cart');
			updateListView();
		}
	}
	void _RemoveQuantity(BuildContext context, Cart note,int quantity) async {
		if (note.quantity <= 0) {
			  _delete(context,note);
		}
		else {
			int result = await databaseHelper.updateQuantityNote(
					note.id, note.quantity--);
			if (result != 0) {
				_showSnackBar(context, note.productName+' removed from cart');
				updateListView();
			}
		}
	}




	void _showSnackBar(BuildContext context, String message) {

		final snackBar = SnackBar(content: Text(message),
			backgroundColor: Colors.blue,
				behavior: SnackBarBehavior.fixed,
				shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(10),
						side: BorderSide(
							color: Colors.blue,
							width: 2,
						)));

		Scaffold.of(context).showSnackBar(snackBar);
	}

  void navigateToDetail(Cart note, String title) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return NoteDetail(note, title);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }

  void updateListView() {

		final Future<Database> dbFuture = databaseHelper.initializeDatabase();
		dbFuture.then((database) {

			Future<List<Cart>> noteListFuture = databaseHelper.getNoteList();
			noteListFuture.then((noteList) {
				setState(() {
				  this.noteList = noteList;
				  this.count = noteList.length;
				});
			});
		});
  }
}







