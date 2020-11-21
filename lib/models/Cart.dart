
import 'dart:ffi';

class Cart {

	int _id;
	String _orderID;
	String _productName;
	int _productID;
	int _providerID;
	String _providerName;
	String _productImage;
	int _productPrice;
	int _quantity;
	String _dateTime;


	Cart(this._orderID,this._providerID,this._providerName,this._productID,this._productName,this._productImage,this._productPrice,this._quantity, this._dateTime);
	Cart.withId(this._id,this._orderID,this._providerID, this._providerName,this._productID,this._productName,this._productImage,this._productPrice,this._quantity, this._dateTime);

	int get id => _id;
	String get orderID => _orderID;
	int get productID => _productID;
	String get productName => _productName;
	String get providerName => _providerName;
	String get productImage => _productImage;
	int get productPrice => _productPrice;
	int get quantity => _quantity;
	String get dateTime => _dateTime;


	set orderID(String orderID) {
			this._orderID = orderID;
		
	}
	
	set productID(int productid) {
		if (productid>=1) {
			this._productID = productid;
		}
	}

	set productName(String productName) {
			this._productName = productName;
	}

	set providerName(String providerName) {
		this._providerName = providerName;

	}
	set productImage(String pimage) {
		this._productImage = pimage;

	}
	set productPrice(int productPrice) {
		this._productPrice = productPrice;

	}
	set quantity(int quantity) {

			this._quantity = quantity;

	}

	set dateTime(String newDate) {
		this._dateTime = newDate;
	}

	// Convert a Note object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['ID'] = _id;
		}
		map['OrderID'] = _orderID;
		map['ProviderID'] = _providerID;
		map['ProviderName'] = _providerName;
		map['ProductID'] = _productID;
		map['ProductName'] = _productName;
		map['ProductImage'] = _productImage;
		map['ProductPrice'] = _productPrice;
		map['Quantity'] = _quantity;
		map['DateTime'] = _dateTime;

		return map;
	}

	// Extract a Note object from a Map object
	Cart.fromMapObject(Map<String, dynamic> map) {
		this._id = map['ID'];
		this._orderID = map['OrderID'];
		this._providerID = map['ProviderID'];
		this._providerName = map['ProviderName'];
		this._productID = map['ProductID'];
		this._productName= map['ProductName'];
		this._productImage= map['ProductImage'];
		this._productPrice= map['ProductPrice'];
		this._quantity = map['Quantity'];
		this._dateTime = map['DateTime'];
	}

	Map<String,dynamic> toJson(){
		return {

		"OrderID":this._orderID,
			"ProductID": this._productID,
			"ProductName": this._productName,

		};
	}
}









