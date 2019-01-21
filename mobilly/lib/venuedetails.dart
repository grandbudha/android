/*
Class to get the Venue Item from JSON.
*/
class VenueDetails{

  /* Saves the name for the searched venue */
  String name;
  /* Saves the address for the searched venue */
  String address;
  /* Saves the street info for the searched venue */
  String street;
  /* Saves tge city info for the searched venue */
  String city;
  /* Saves the state info for the searched venue */
  String state;
  /* Saves the country info for the searched venue */
  String country;
  /* Saves the distance info for the seached venue in miles */
  num distance;
  
  /* Constructor */
  VenueDetails({
    this.name,
    this.address,
    this.street,
    this.city,
    this.state,
    this.country,
    this.distance
  });

  /* 
   PUR: Get the venue info from the JSON object.
   PRE: @param 'response' stores the JSON array.
        @param 'totalResults' stores the total number of objects insdie @param 'response'.
   RET: Returns the List object for VenueDetails class.
  */
  List<VenueDetails> fromJson(var response, num totalResults){

    List<VenueDetails> listVenueDetails = List<VenueDetails>();
    for(int i = 1; i < totalResults; ++i){

      
      var itemJson = response[i];
      var venueList = itemJson['venue'];
    
      String name = venueList['name'];
      if(name == null) name = '';
    
      var addressList = venueList['location'];
      num distance = addressList['distance'];
      String address = addressList['address'];
      if(address == null) address = '';
      String crossStreet = addressList['crossStreet'];
      if(crossStreet == null) crossStreet = '';
      String city = addressList['city'];
      if(city == null) city = '';
      String state = addressList['state'];
      if(state == null) state = '';
      String country = addressList['country'];
      if(country == null) country = '';
      /* Add up the value inside list variable */
      listVenueDetails.add(new VenueDetails(
        name: name,
        address: address,
        street: crossStreet,
        city: city,
        state: state,
        country: country,
        distance: distance
      ));
    }
    /* return the list object */
    return listVenueDetails; 
  }// end
}// END