import 'package:flutter/material.dart';
import 'package:mobilly/view.dart';
import 'package:mobilly/presenter.dart';
import 'package:mobilly/venuedetails.dart';
import 'package:mobilly/listitems.dart';

/*
 Starting point of a flutter applicaiton.
*/
void main(){

  final String title = 'Mobilly';

  /* Start the application */
  runApp(
    /* Create material app which uses material design guidelines */
    MaterialApp(
      title: title,
      home: Scaffold(
        
        /* App bar for an application */
        appBar: AppBar(
          title: Text('$title'),
        ),

        /* Body of an application */
        body: SearchVenue(),
      ),
    )  
  );
}// end

/* 
 StatefulWidget type class to handle the user search.
*/
class SearchVenue extends StatefulWidget {

  final String title = 'Mobilly';

  @override
  _SearchMenuState createState() => _SearchMenuState(); // end
}// END

/* 
 State objext for the above StatefulWidget class.
 Implements the View interface of MVP.
*/
class _SearchMenuState extends State<SearchVenue> implements ViewController{
  
  /* Unique form key for a form */
  final _formKey = GlobalKey<FormState>();
  /* TextController which saves the value of TextArea */
  final searchTextController = TextEditingController();
  /* Reference variable of Presenter from MVP */
  Presenter presenter;

  /* Method to initialize the state of StatefulWidget */
  @override
  void initState(){
    super.initState();
    presenter = Presenter(textEditingController: searchTextController,
    viewController: this, context: this.context);
  }// end

  /* Destroys the already intialized state for an StatefulWidget */
  @override
  void dispose(){
    searchTextController.dispose();
    super.dispose();
  }// end

  /*
   PUR: Draws out the TextFormField at the center of the screen.
        Handles validation of user input.
        Show Snackbar while processing the user search request.
   PRE: @param 'context' is the context variable for an app.
   RET: Returns widget.
  */
  Widget widgetBody(BuildContext context){

    var showTextAreaInCenter = Center(
      child: TextFormField(
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.black87,
        ),
        validator: (value){
          if(value.isEmpty){
            return 'Please enter some text';
          }
        },
        controller: searchTextController,
        decoration: InputDecoration(
          
          /* Make textArea matches Material design guidelines */
          border: OutlineInputBorder(
            
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(
              color: Colors.blue[600],
              style: BorderStyle.solid,
              width: 10.0,
            ),
          ),

          labelText: 'Search Nearby venues',
          labelStyle: TextStyle(
            fontSize: 16.0,
            
          ),
          contentPadding: EdgeInsets.fromLTRB(12.0, 14.0, 12.0, 14.0),
          /* Suffix icon */
          suffixIcon: IconButton(
              icon: Icon(Icons.search),
              iconSize: 25.0,
              splashColor: Colors.blue[600],
              color: Colors.black87,
              onPressed: (){
              
                /* If TextField is epty show Snackbar */
                if(_formKey.currentState.validate()){
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Processing request'),
                    )
                  ); 
                  /* Call the presenter method */
                  presenter.getNearestVenueResult();  
                }
              },
          ),
        ),
      ),
    );

    /* Call above functions accordingly */
    return Container(
      margin: EdgeInsets.all(12.0),
      child: showTextAreaInCenter,
    );
  }// end

  /*
   Override method to build the widget onto the screen.
  */
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: widgetBody(context),
    );
  }// end

  /*
   PUR: Method of ViewController from MVP.
        handles the creation of new screen with the search result.
   PRE: @param 'listVenueItems' is the list object for VenueDetails type object.
        @param 'context' saves the reference of current screen context.
   RET: Mone.
  */
  @override
  void getSearchTextFromController(List<VenueDetails> listVenueItems, BuildContext context) {

    /* Create new screen with list items */
    printVenueDetails(listVenueItems, context);
  }// end

  /* 
   PUR: handles the creation of new screen.
   PRE: @param 'listVenueItems' is the list object for VenueDetails type object.
        @param 'context' saves the reference of current screen context.
   RET: Mone.
  */
  void printVenueDetails(List<VenueDetails> listVenuItems, BuildContext context){

    Navigator.push(context, 
      MaterialPageRoute(
        builder: (context) => ListItems(listVenuItems: listVenuItems)
      ),
    );
  }// end
}// END



