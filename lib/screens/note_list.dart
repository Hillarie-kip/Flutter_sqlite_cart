import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants/colors.dart';
import 'package:flutter_app/models/Cart.dart';
import 'package:flutter_app/utils/database_helper.dart';
import 'package:flutter_app/screens/note_detail.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';


class CartList extends StatefulWidget {

	@override
  State<StatefulWidget> createState() {

    return CartListState();
  }
}

class CartListState extends State<CartList> {

	DatabaseHelper databaseHelper = DatabaseHelper();
	List<Cart> cartList;
	int count = 0;


	var now = DateTime.now();
	get weekDay => DateFormat('EEEE').format(now);
	get day => DateFormat('dd').format(now);
	get month => DateFormat('MMMM').format(now);


	ScrollController scrollController = ScrollController();
	@override
  Widget build(BuildContext context) {
		if (cartList == null) {
			cartList = List<Cart>();
			updateListView();
		}
		
		return Scaffold(
			appBar: AppBar(
				// leading: Icon(Icons.toc),
					backgroundColor: Colors.green,
					title: Text("MyHome"),
					actions: <Widget>[
			IconButton(icon: Icon(Icons.filter_list),
			color: Colors.green,
			splashColor: Colors.green,
			highlightColor: Colors.green,
			onPressed: ()  {

				})
		]

		),
			body:
			Container(
				child: CustomScrollView(
					slivers: <Widget>[
						SliverGrid(
							gridDelegate:
							SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
							delegate: SliverChildListDelegate(
					[
									getNoteListView()

								],
							),
						),
						SliverList(
							delegate: SliverChildListDelegate(
								[
									
									SizedBox(
										height: 10,
									),
									PromoCodeWidget(),
									SizedBox(
										height: 10,
									),
									TotalCalculationWidget(),
									SizedBox(
										height: 10,
									),
									Container(
										padding: EdgeInsets.only(left: 5),
										child: Text(
											"Payment Method",
											style: TextStyle(
													fontSize: 20,
													color: Color(0xFF3a3a3b),
													fontWeight: FontWeight.w600),
											textAlign: TextAlign.left,
										),
									),
									SizedBox(
										height: 10,
									),
									PaymentMethodWidget(),
									checkoutButton(context,cartList)
								],
							),
						),


					],
				),
			),


	    floatingActionButton: FloatingActionButton(
		    onPressed: () {
		      debugPrint('FAB clicked');
		      navigateToDetail(Cart('123456', 1,'Hilla Restaurant', 2,'Pizza','12345',2000,1,''), 'Add Cart');
		    },

		    tooltip: 'Add Cart',

		    child: Icon(Icons.add),

	    ),
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

	void _delete(BuildContext context, Cart note) async {

		int result = await databaseHelper.deleteCartItem(note.id);
		if (result != 0) {
			_showSnackBar(context, 'Note Deleted Successfully');
			updateListView();
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
		  return CartDetail(note, title);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }

  void updateListView() {

		final Future<Database> dbFuture = databaseHelper.initializeDatabase();
		dbFuture.then((database) {

			Future<List<Cart>> noteListFuture = databaseHelper.getNoteList("123456");
			noteListFuture.then((noteList) {
				setState(() {
				  this.cartList = noteList;
				  this.count = noteList.length;
				});
			});
		});
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
									child: Image.network(cartList[position].productImage),
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
												cartList[position].productName,
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
													onTap: () => _RemoveQuantity(context,cartList[position],cartList[position].quantity--),
													child: Icon(Icons.remove_circle),
												),
												Padding(
													padding: EdgeInsets.symmetric(horizontal: 16.0),
													child: Text('${cartList[position].quantity.toString()}', style: titleStyle),
												),
												InkWell(
													onTap: () => _AddQuantity(context,cartList[position],cartList[position].quantity++),
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
												'\$ ${cartList[position].quantity*cartList[position].productPrice}',
												style: titleStyle,
												textAlign: TextAlign.end,
											),
										),
										Card(
											shape: roundedRectangle,
											color: mainColor,
											child: InkWell(
											onTap: () =>  _delete(context,cartList[position]),
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

	void _AddQuantity(BuildContext context, Cart cartlist,int quantity) async {

		int result = await databaseHelper.updateQuantityCart(cartlist.id,cartlist.quantity++);
		if (result != 0) {
			_showSnackBar(context, cartlist.productName+' added to cart');
			updateListView();
		}
	}
	void _RemoveQuantity(BuildContext context, Cart note,int quantity) async {
		if (note.quantity <= 0) {
			_delete(context,note);
		}
		else {
			int result = await databaseHelper.updateQuantityCart(
					note.id, note.quantity--);
			if (result != 0) {
				_showSnackBar(context, note.productName+' removed from cart');
				//	updateListView();
			}
		}
	}



}


class PaymentMethodWidget extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Container(
			alignment: Alignment.center,
			width: double.infinity,
			height: 60,
			decoration: BoxDecoration(boxShadow: [
				BoxShadow(
					color: Color(0xFFfae3e2).withOpacity(0.1),
					spreadRadius: 1,
					blurRadius: 1,
					offset: Offset(0, 1),
				),
			]),
			child: Card(
				color: Colors.white,
				elevation: 0,
				shape: RoundedRectangleBorder(
					borderRadius: const BorderRadius.all(
						Radius.circular(5.0),
					),
				),
				child: Container(
					alignment: Alignment.center,
					padding: EdgeInsets.only(left: 10, right: 30, top: 10, bottom: 10),
					child: Row(
						children: <Widget>[
							Container(
								alignment: Alignment.center,
								child: Image.asset(
									"assets/images/menus/ic_credit_card.png",
									width: 50,
									height: 50,
								),
							),
							Text(
								"Credit/Debit Card",
								style: TextStyle(
										fontSize: 16,
										color: Color(0xFF3a3a3b),
										fontWeight: FontWeight.w400),
								textAlign: TextAlign.left,
							)
						],
					),
				),
			),
		);
	}
}

class TotalCalculationWidget extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Container(
			alignment: Alignment.center,
			width: double.infinity,
			height: 150,
			decoration: BoxDecoration(boxShadow: [
				BoxShadow(
					color: Color(0xFFfae3e2).withOpacity(0.1),
					spreadRadius: 1,
					blurRadius: 1,
					offset: Offset(0, 1),
				),
			]),
			child: Card(
				color: Colors.white,
				elevation: 0,
				shape: RoundedRectangleBorder(
					borderRadius: const BorderRadius.all(
						Radius.circular(5.0),
					),
				),
				child: Container(
					alignment: Alignment.center,
					padding: EdgeInsets.only(left: 25, right: 30, top: 10, bottom: 10),
					child: Column(
						children: <Widget>[
							SizedBox(
								height: 15,
							),
							SizedBox(
								height: 15,
							),
							Row(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								children: <Widget>[
									Text(
										"Total",
										style: TextStyle(
												fontSize: 18,
												color: Color(0xFF3a3a3b),
												fontWeight: FontWeight.w600),
										textAlign: TextAlign.left,
									),
									Text(
										"\$292",
										style: TextStyle(
												fontSize: 18,
												color: Color(0xFF3a3a3b),
												fontWeight: FontWeight.w600),
										textAlign: TextAlign.left,
									)
								],
							),
						],
					),
				),
			),
		);
	}
}

class PromoCodeWidget extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return SafeArea(
			child: Container(
				padding: EdgeInsets.only(left: 3, right: 3),
				decoration: BoxDecoration(boxShadow: [
					BoxShadow(
						color: Color(0xFFfae3e2).withOpacity(0.1),
						spreadRadius: 1,
						blurRadius: 1,
						offset: Offset(0, 1),
					),
				]),
				child: TextFormField(
					decoration: InputDecoration(
							focusedBorder: OutlineInputBorder(
								borderSide: BorderSide(color: Color(0xFFe6e1e1), width: 1.0),
							),
							enabledBorder: OutlineInputBorder(
									borderSide: BorderSide(color: Color(0xFFe6e1e1), width: 1.0),
									borderRadius: BorderRadius.circular(7)),
							fillColor: Colors.white,
							hintText: 'Add Your Promo Code',
							filled: true,
							suffixIcon: IconButton(
									icon: Icon(
										Icons.local_offer,
										color: Color(0xFFfd2c2c),
									),
									onPressed: () {
										debugPrint('222');
									})),
				),
			),
		);
	}
}


class AddToCartMenu extends StatelessWidget {
	int productCounter;

	AddToCartMenu(this.productCounter);

	@override
	Widget build(BuildContext context) {
		return Container(
			child: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
					IconButton(

						icon: Icon(Icons.remove),
						color: Colors.black,
						iconSize: 18,
					),
					InkWell(
						onTap: () => print('hello'),
						child: Container(
							width: 100.0,
							height: 35.0,
							decoration: BoxDecoration(
								color: Color(0xFFfd2c2c),
								border: Border.all(color: Colors.white, width: 2.0),
								borderRadius: BorderRadius.circular(5.0),
							),
							child: Center(
								child: Text(
									'Add To $productCounter',
									style: new TextStyle(
											fontSize: 12.0,
											color: Colors.white,
											fontWeight: FontWeight.w300),
								),
							),
						),
					),
					IconButton(
						onPressed: () {},
						icon: Icon(Icons.add),
						color: Color(0xFFfd2c2c),
						iconSize: 18,
					),
				],
			),
		);
	}
}









