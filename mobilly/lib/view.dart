import 'package:flutter/material.dart';
import 'package:mobilly/venuedetails.dart';

/* 
Abstract class to work as a View in MVP model.
*/
abstract class ViewController {

  /*
  Interface handler for Model and Presenter. 
  */
  void getSearchTextFromController(List<VenueDetails> listVenueItems, BuildContext context);
}// end