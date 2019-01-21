import 'dart:async';
import 'dart:convert' ;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobilly/view.dart';
import 'package:mobilly/venuedetails.dart';

/*
 Presenter class for the MVP model.
*/
class Presenter {

  /* Reference variable for View */
  ViewController viewController;
  /* Context reference variable for current application */
  BuildContext context;
  /* Stores the result string from Flutter channel */
  String _resultString = 'No result found.';
  /* path for the communication channel between Flutter and Java */
  static const String COMMUNICATION_CHANNEL= 'samples.flutter.io/search_venue';
  /* Initialize the method channel for the above communication channel */
  static const javaPlatform = const MethodChannel(COMMUNICATION_CHANNEL);
  /* Name of the Java method which needs to be called from Flutter  */
  String javaMethodName = 'getVenueResults';
  /* Text editing controller for TextArea to fetch input given by user */
  final TextEditingController textEditingController;
  /* Base URL address for the Foursquare search API */
  static const String BASE_URL = 'https://api.foursquare.com/v2/venues/explore';
  /* HTTP success status code */
  static const num SUCCESS_STATUS_CODE = 200;
  /* Refernce variable for VenuDetails type of list */
  List<VenueDetails> listVenueDetails;

  /* Constructor to create the object */
  Presenter({this.viewController, this.textEditingController, this.context});

  /*  
   PUR: Get the information for nearest venue avilable.
        Uses the Flutter channel to call backend Java method. 
   PRE: None.
   RET: Saves the return result inside class variable '_resultString'.
  */
  Future<void> getNearestVenueResult() async {

    /* Get the search result for user using Flutter channel */
    try {
      final String result = await javaPlatform.invokeMethod(javaMethodName, textEditingController.text);
      _resultString = result;
      
      /* Make the HTTP request using REST API */
      getJSONFromNetwork();
    } catch(e) {
      _resultString = 'Failed to get results for nearest venue. ${e.toString()}';
    }
  }// end

  /*
  PUR: Makes the HTTP request using REST API,
  PRE: None.
  RET: Returns the list of Venue details items.
  */
  Future<void> getJSONFromNetwork() async{

    String url = BASE_URL + _resultString;
    
    /* Get JSON using http */
    var response = await http.get(url);
    if(response.statusCode == SUCCESS_STATUS_CODE){

      /* On Success, parse the JSON for valid object type*/ 
      var apiJson = json.decode(response.body);
      
      /* Fetch the response JSON field */
      var responseJson = apiJson['response'];
      var totalResults = responseJson['totalResults'];
      
      /* Fetch the group JSON field */
      var groupJsonMap = responseJson['groups'].cast<Map<String, dynamic>>();
      var groupJson = groupJsonMap[0];
      
      /* Get items JSON field */
      var itemJsonMap = groupJson['items'].cast<Map<String, dynamic>>();
  
      /* Get the list for all the venues inside JSON */
      listVenueDetails = VenueDetails().fromJson(itemJsonMap, totalResults);

      /* Call the View interface to make List */
      viewController.getSearchTextFromController(listVenueDetails, context);
    }
    else {
      /* Throw an exception */
      throw Exception('Failed to load JSON from API,');
    }
  }// end
}// END