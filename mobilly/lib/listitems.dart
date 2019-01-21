import 'package:flutter/material.dart';
import 'package:mobilly/venuedetails.dart';

/*
 Statefulwidget class which gets created after receiving the venue items.
*/
class ListItems extends StatefulWidget{
  
  /* Refernce variable to store list of venues. */
  final List<VenueDetails> listVenuItems;
  
  /* Constructor */
  ListItems({this.listVenuItems});
  
  @override
  _ListItemsState createState() => _ListItemsState();
}// END

/*
 Class to store and create state for StatefulWidget class.
*/
class _ListItemsState extends State<ListItems>{
  
  /* Constant to convert Meters to Miles. */
  static const num METER_TO_MILES = 1609.34;

  /* Override class method to draw layout onto screen. */
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Search result'),
        ),
        body: ListView.builder(
          itemCount: widget.listVenuItems.length,
          itemBuilder: (context, index){
            return itemCard(context, widget.listVenuItems[index]);
          },
        )

      ),
    );
  }// end

 /*
  PUR:Creats the card for the venue item.
  PRE: @param 'context' is the reference variable for application context.
       @param 'item' contains the item which requires the card. 
  RET: Returns the card widget.
 */
  Widget itemCard(BuildContext context, VenueDetails item){

    return Card(
      margin: EdgeInsets.all(6.0),
      elevation: 6.0,
      
      child: Column(
        mainAxisSize: MainAxisSize.min,
        
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
          ),
          ListTile(
            title: Text(item.name,style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),),
            subtitle: Text(makeFormatedAddress(item),style: TextStyle(
              fontSize: 13.0,
              color: Colors.black45,
            ),),
            trailing: Text(convertMetersToMiles(item.distance)),
          ),
        ],
      ),
    );
  }// end

  /*
   PUR: Convert meter distance to miles.
   PRE: @param 'distance' is the distance in meter.
   RET: Returns string with 2 decimal precision.
  */
  String convertMetersToMiles(num distance){
    num result = (distance / METER_TO_MILES);
    return result.toStringAsFixed(2) + ' Mi';
  }// end

  /*
   PUR: make the proper formated address string for the current venue.
   PRE: @param 'item' contains the item which needs to be formatted.
   RET: Return formated string.
  */
  String makeFormatedAddress(VenueDetails item){
    String comma = ', ';
    
    return (item.address != ''?(item.address + comma):'') +
            (item.street != ''?(item.street + comma):'') +
            item.city + comma + item.state + comma + item.country; 
  }// end
}// END

