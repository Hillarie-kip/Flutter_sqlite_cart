import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Cart.dart';
import 'package:flutter_app/utils/database_helper.dart';
import 'package:intl/intl.dart';

class CartDetail extends StatefulWidget {

	final String appBarTitle;
	final Cart cartItem;

	CartDetail(this. cartItem, this.appBarTitle);

	@override
  State<StatefulWidget> createState() {

    return CartDetailState(this.cartItem, this.appBarTitle);
  }
}

class CartDetailState extends State<CartDetail> {

	DatabaseHelper helper = DatabaseHelper();

	String appBarTitle;
	Cart cartItem;

	TextEditingController titleController = TextEditingController();
	TextEditingController descriptionController = TextEditingController();
	TextEditingController quantityController = TextEditingController();

	CartDetailState(this.cartItem, this.appBarTitle);

	@override
  Widget build(BuildContext context) {

		TextStyle textStyle = Theme.of(context).textTheme.title;

		titleController.text = cartItem.productName;
		descriptionController.text = cartItem.providerName;

    return WillPopScope(

	    onWillPop: () {
	    	// Write some code to control things, when user press Back navigation button in device navigationBar
		    moveToLastScreen();
	    },

	    child: Scaffold(
	    appBar: AppBar(
		    title: Text(appBarTitle),
		    leading: IconButton(icon: Icon(
				    Icons.arrow_back),
				    onPressed: () {
		    	    // Write some code to control things, when user press back button in AppBar
		    	    moveToLastScreen();
				    }
		    ),
	    ),

	    body: Padding(
		    padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
		    child: ListView(
			    children: <Widget>[

			    	// First element

						Padding(
							padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
							child: TextField(
								controller: quantityController,
								style: textStyle,
								onChanged: (value) {
									updateQuantity();
								},
								decoration: InputDecoration(
										labelText: 'Quantity',
										labelStyle: textStyle,
										border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(5.0)
										)
								),
							),
						),
				    // Second Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: titleController,
						    style: textStyle,
						    onChanged: (value) {
						    	debugPrint('Something changed in Title Text Field');
						    	updateTitle();
						    },
						    decoration: InputDecoration(
							    labelText: 'Title',
							    labelStyle: textStyle,
							    border: OutlineInputBorder(
								    borderRadius: BorderRadius.circular(5.0)
							    )
						    ),
					    ),
				    ),

				    // Third Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: descriptionController,
						    style: textStyle,
						    onChanged: (value) {
							    debugPrint('Something changed in Description Text Field');
							    updateDescription();
						    },
						    decoration: InputDecoration(
								    labelText: 'Description',
								    labelStyle: textStyle,
								    border: OutlineInputBorder(
										    borderRadius: BorderRadius.circular(5.0)
								    )
						    ),
					    ),
				    ),

				    // Fourth Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: Row(
						    children: <Widget>[
						    	Expanded(
								    child: RaisedButton(
									    color: Theme.of(context).primaryColorDark,
									    textColor: Theme.of(context).primaryColorLight,
									    child: Text(
										    'Save',
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
									    	setState(() {
									    	  debugPrint("Save button clicked");
									    	  _save();
									    	});
									    },
								    ),
							    ),

							    Container(width: 5.0,),

							    Expanded(
								    child: RaisedButton(
									    color: Theme.of(context).primaryColorDark,
									    textColor: Theme.of(context).primaryColorLight,
									    child: Text(
										    'Delete',
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
										    setState(() {
											    debugPrint("Delete button clicked");
											    _delete();
										    });
									    },
								    ),
							    ),

						    ],
					    ),
				    ),

			    ],
		    ),
	    ),

    ));
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }

	// Convert the String priority in the form of integer before saving it to Database


	// Convert int priority to String priority and display it to user in DropDown

	void updateQuantity(){
		cartItem.quantity = quantityController.text as int;
	}

	// Update the title of Note object
  void updateTitle(){
    cartItem.productName = titleController.text;
  }

	// Update the description of Note object
	void updateDescription() {
		cartItem.providerName = descriptionController.text;
	}

	// Save data to database
	void _save() async {

		moveToLastScreen();

		cartItem.dateTime = DateFormat.yMMMd().format(DateTime.now());
		int result;
		if (cartItem.id != null) {  // Case 1: Update operation
			result = await helper.updateCart(cartItem);
		} else { // Case 2: Insert Operation
			result = await helper.insertCart(cartItem);
		}

		if (result != 0) {  // Success
			_showAlertDialog('Status', 'Product Saved Successfully');
		} else {  // Failure
			_showAlertDialog('Status', 'Problem Saving Note');
		}

	}
	void _delete() async {

		moveToLastScreen();
		// Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
		// the detail page by pressing the FAB of NoteList page.
		if (cartItem.id == null) {
			_showAlertDialog('Status', 'No Product was deleted');
			return;
		}

		// Case 2: User is trying to delete the old note that already has a valid ID.
		int result = await helper.deleteCartItem(cartItem.id);
		if (result != 0) {
			_showAlertDialog('Status', 'Product Deleted Successfully');
		} else {
			_showAlertDialog('Status', 'Error Occured while Deleting Product');
		}
	}

	void _showAlertDialog(String title, String message) {

		AlertDialog alertDialog = AlertDialog(
			title: Text(title),
			content: Text(message),
		);
		Future.delayed(Duration(seconds: 1), () {
			Navigator.of(context).pop(true);
		});
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}

	

}










