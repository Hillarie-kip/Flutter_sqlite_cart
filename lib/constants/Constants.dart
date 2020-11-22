
import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {
}
class URLs{

  static const BASE_URL = 'http://coke.esquekenya.com/api/';

  static const URL_SERVICEIMAGE =
      BASE_URL + "MyHomeFile/ServiceTypeImage?ImageID=";
  static const URL_SERVICEPROVIDERIMAGE =
      BASE_URL + "MyHomeFile/ServiceProviderImage?ImageID=";
  static const URL_SERVICECATEGORYIMAGE =
      BASE_URL + "MyHomeFile/ServiceCategoryImage?ImageID=";
  static const URL_SERVICEPRODUCTIMAGE =BASE_URL+"MyHomeFile/ServiceProductImage?ImageID=";





}

class LoginData{
static const String USERID = 'UserID';
static const String FNAME = "FirstName";
static const String LNAME = "LastName";
static const String PHONE = 'PhoneNumber';
static const String EMAIL = 'PhoneNumber';
static const String PASSWORD = 'Password';
static const String USERIMAGE = "UserImage";
static const String USERTYPE = "UserType";
static const String HOUSENO = "HouseNO";
static const String HOUSEID = "HouseID";
static const String APARTMENTID = "ApartmentID";
static const String APARTMENTNAME = "ApartmentName";
static const String HASRESETPASSWORD = "HasResetPassword";
}

class AppColors{


    static const PrimaryColor = Color(0xFF453658);
  static const colorAccent = Color(0xFFFFC000);
  static const colorAccentLight = Color(0xFFFFC000);

  static const PrimaryDarkColor = Color(0xFF392850);
  static const ErroColor = Color(0xFF808080);
  static const white = Color(0xFFf2f2f2);
  static const black = Color(0xFF000000);
  static const whitish = Color(0xFFe6e6e6);

  static const orange = Color(0xFFfa6b19);
  static const red = Color(0xFFE90A0A);
  static const green = Color(0xFF13C003);
  static const yellow = Color(0xFFFFC000);
}



const String FUNGUO= 'XXX';
const String APIKEY= 'Funguo';
//screens
final String SIGN_IN = 'signin';
final String SIGN_UP ='signup';
final String PROFILE ='Profile';
final String splashScreen ='splashscreen';

final String dashboard ='DashBoard';
final String myHomeServices ='Services';

final String addUpdateProperty ='addUpdateProperty';
const Color primary = Colors.deepOrange;
const  red = Colors.red;
const Color white = Colors.white;
const Color black = Colors.black;
const Color grey = Colors.grey;
const Color green = Colors.green;