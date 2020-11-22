import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants/Constants.dart';
import 'package:flutter_app/models/Cart.dart';
import 'package:flutter_app/utils/cartIconWithBadge.dart';
import 'package:flutter_app/utils/database_helper.dart';
import 'package:flutter_app/screens/CartDetail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'CheckOutPage.dart';


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
					backgroundColor: AppColors.PrimaryDarkColor,
					title: Text("MyHome"),
					actions: <Widget>[
			cartIconWithBadge()
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
									createSubTitle(),

									SizedBox(
										height: 10,
									),
									PromoCodeWidget(),
									SizedBox(
										height: 10,
									),
									footer(context),
									SizedBox(
										height: 10,
									),
									],
							),
						),


					],
				),
			),


	    floatingActionButton: FloatingActionButton(
		    onPressed: () {
		      debugPrint('FAB clicked');
		      navigateToDetail(Cart('123456', 1,'Hilla Restaurant', 2,'Pizza','123',2000,1,''), 'Add Cart');
		    },

		    tooltip: 'Add Cart',

		    child: Icon(Icons.add),

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
			backgroundColor: AppColors.colorAccent,
				behavior: SnackBarBehavior.fixed,
				shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(10),
						side: BorderSide(
							color: AppColors.colorAccent,
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

	Widget getNoteListView() {


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
								flex: 4,
								fit: FlexFit.tight,
								child: ClipRRect(
									borderRadius: BorderRadius.all(Radius.circular(16)),
									child: Image.network(URLs.URL_SERVICEPRODUCTIMAGE+cartList[position].productImage),
								),
							),
							Flexible(
								flex: 4,
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.center,
									mainAxisAlignment: MainAxisAlignment.spaceBetween,
									children: <Widget>[
										Container(
											height: 30,
											child: Text(cartList[position].productName,
												style: GoogleFonts.poppins(
														textStyle: TextStyle(
																color: AppColors.PrimaryDarkColor,
																fontSize: 18)),
												textAlign: TextAlign.center,
											),
										),
										Container(
											height: 50,
											child: Text("provider : "+cartList[position].providerName,
												style: GoogleFonts.poppins(
														textStyle: TextStyle(
																color: AppColors.colorAccent,
																fontSize: 14)),
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
													child: Icon(Icons.remove_circle,color: AppColors.colorAccent,),
												),
												Padding(
													padding: EdgeInsets.symmetric(horizontal: 16.0),
													child: Text('${cartList[position].quantity.toString()}', 	style: GoogleFonts.poppins(
															textStyle: TextStyle(
																	color: AppColors.PrimaryDarkColor,
																	fontSize: 15)),),
												),
												InkWell(
													onTap: () => _AddQuantity(context,cartList[position],cartList[position].quantity++),
													child: Icon(Icons.add_circle,color:AppColors.colorAccent),
												),
											],
										),


										Container(

											height: 50,
											child: Text('\KES${cartList[position].quantity*cartList[position].productPrice}',
												style: GoogleFonts.poppins(
														textStyle: TextStyle(
																color: AppColors.colorAccent,
																fontSize: 14)),
												textAlign: TextAlign.center,
											),
										),
									],
								),
							),
							Flexible(
								flex: 5,
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.end,
									mainAxisAlignment: MainAxisAlignment.end,
									children: <Widget>[
										Container(
											height: 40,
											width: 80,
											child: Text(
												'\KES ${cartList[position].quantity*cartList[position].productPrice}',
													style: GoogleFonts.poppins(
											textStyle: TextStyle(
											color: AppColors.PrimaryDarkColor,
													fontSize: 15)),
												textAlign: TextAlign.end,
											),
										),
										Card(
											child: InkWell(
											onTap: () =>  _delete(context,cartList[position]),
												child: Icon(Icons.delete_forever,color: AppColors.red,),
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



	createSubTitle() {
		return Container(
			alignment: Alignment.topLeft,
			child: Text(
				"Total Items : "+cartList.length.toString(),	style: GoogleFonts.poppins(
					textStyle: TextStyle(
							color: AppColors.colorAccent,
							fontSize: 14)),
				textAlign: TextAlign.center,
			),
			margin: EdgeInsets.only(left: 12, top: 4),
		);
	}
	footer(BuildContext context) {
		return Container(
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.center,
				mainAxisAlignment: MainAxisAlignment.end,
				children: <Widget>[
					Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: <Widget>[
							Container(
								margin: EdgeInsets.only(left: 30),
								child: Text(
									"Total",
									style: GoogleFonts.poppins(
											textStyle: TextStyle(
													color: AppColors.colorAccent,
													fontSize: 14)),
									textAlign: TextAlign.center,
								),
							),
							Container(
								margin: EdgeInsets.only(right: 30),
								child: Text(
									"\$299.00",
									style: GoogleFonts.poppins(
											textStyle: TextStyle(
													color: AppColors.colorAccent,
													fontSize: 14)),
									textAlign: TextAlign.center,
								),
							),
						],
					),
					SizedBox(height: 8),
					RaisedButton(
						onPressed: () {
							Navigator.push(context,
								new MaterialPageRoute(builder: (context) => CheckOutPage()));
						},
						color: AppColors.PrimaryDarkColor,
						padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
						shape: RoundedRectangleBorder(
								borderRadius: BorderRadius.all(Radius.circular(24))),
						child: Text(
							"Checkout",	style: GoogleFonts.poppins(
								textStyle: TextStyle(
										color: AppColors.white,
										fontSize: 14)),
							textAlign: TextAlign.center,
						),
					),
					SizedBox(height: 8),
				],
			),
			margin: EdgeInsets.only(top: 16),
		);
	}
	PromoCodeWidget() {
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
					updateListView();
			}
		}
	}



}

















