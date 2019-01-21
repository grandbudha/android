package com.example.mobilly;

import android.Manifest;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Build;
import android.os.Bundle;
import java.text.SimpleDateFormat;
import java.util.Date;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  /* Communication channel between Java and Flutter */
  private static final String FLUTTER_CHANNEL = "samples.flutter.io/search_venue";

  /* Method name which flutter is suppose to make */
  private String flutterMethodCall = "getVenueResults";

  /* Class object for GetLocation */
  GetLocation getLocationObj;

  /* Saves the current latitude coordinates */
  double latitude;

  /* Saves the current longitude coordinates */
  double longitude;

  /* Saves the current date for API versioning */
  String currentDate;

  /* Saves the name of permission which we require to get user location */
  String fineLocationPermission = Manifest.permission.ACCESS_FINE_LOCATION;

  /* Request code to check the fine location permission */
  private static final int PERMISSION_ACCESS_FINE_LOCATION_REQUEST_CODE = 111;

  /* Search details entered by user */
  String searchQuery;

  /* String result which needs to be returned back from Java to Flutter */
  String resultString = "";

  /* Client ID API key  */
  private static final String API_CLIENT_ID = "F2BSGV3S0FIPQZ5WWHZAOMBLSQRU4KJC3CAYHXJX4QL1HNOX";

  /* Client secret  API key */
  private static final String API_CLIENT_SECRET = "KEDTMCXRKUB55YZ03QZH0AQEHQLURIS1PTBJOB5EAU1SXSBP";

  /* Not enough permission string */
  private String notEnoughPermissionString = "Not enough permissions to access current location, please make sure you Location settings are turned on.";

  /*
   onCreate method provided by android.
   */
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    /* Get the class reference for GetLocation */
    getLocationObj = new GetLocation(getApplicationContext());

    /* Set the flutter call handler */
    new MethodChannel(getFlutterView(), FLUTTER_CHANNEL).setMethodCallHandler(
            new MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall methodCall, Result result) {

                /* Invoke the method if available in Java*/
                if (methodCall.method.equals(flutterMethodCall)){

                  searchQuery = methodCall.arguments();
                  
                  /* Check for the ACCESS_FINE_LOCATION permissions */
                  if(!checkPermissions()){

                    /* Make the permission request */
                    if(Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP_MR1){
                      requestPermissions(new String[]{fineLocationPermission},
                              PERMISSION_ACCESS_FINE_LOCATION_REQUEST_CODE);
                    }
                  }
                  /* Get the current location */
                  else {

                    /* Get the part of the API URL*/
                    getVenueResults(searchQuery);

                    if (resultString.length() > 0) result.success(resultString);
                    else
                      result.error("UNAVAILABLE","Flutter channel for Android is not responding.", null);
                  }
                }
                /* Return not implemented result */
                else {
                  result.notImplemented();
                }
              }
            });
  }// end

  /*
   Activity method to check the requested permission result.
   */
  @Override
  public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    //super.onRequestPermissionsResult(requestCode, permissions, grantResults);

    if(requestCode == PERMISSION_ACCESS_FINE_LOCATION_REQUEST_CODE){

      /* Check if user has granted the permission */
      if((grantResults.length == 0) ||(grantResults[0]) != PackageManager.PERMISSION_GRANTED){
        resultString = notEnoughPermissionString;
      }
      /* Get the imput venue results */
      else {
        getVenueResults();
      }
    }
  }// end

  /*
    PUR: Check if the fine location permission is alredy granted
    PRE: None.
    RET: Return true if already granted, else false.
  */
  private boolean checkPermissions(){

    boolean flag = false;

    /* Check for SDK version > 22 */
    if(Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP_MR1){

      int permission = checkSelfPermission(fineLocationPermission);

      /* Check if the permission is already granted */
      if(permission == PackageManager.PERMISSION_GRANTED)
        flag = true;

    }
    return flag;
  }// end

  /*
   PUR: Get the current location of the user.
   PRE: @param 'searchQuery' is the venue name which needs to be searched.
   RET: Returns the dynamic URL as per users current location.
  */
  private String getVenueResults(String searchQuery){

    /* Get the current longitude and latitude */
    if(getLocationObj.getIsCurrentLocation()){

      latitude = getLocationObj.getLatitude();
      longitude = getLocationObj.getLongitude();
    }
    /* Manually call the getCurrentLocation method */
    else {

      Location location = getLocationObj.getCurrentLocation();

      if(location == null){
        resultString = notEnoughPermissionString;
        return resultString;
      }
      else {
        longitude = location.getLongitude();
        latitude = location.getLatitude();
      }
    }

    /* Get the current date for API versioning */
    getCurrentDate();

    /* Make rest of the API URL */
    makeAPIUrl();

    /* Return the URL */
    return resultString;
  }// end

  /*
   PUR: Get the current date for API versioning.
   PRE: None.
   RET: Saves the current date inside 'currentDate' class variable.
   */
  private void getCurrentDate(){

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
    Date date = new Date();
    this.currentDate = dateFormat.format(date);
  }// end

  /*
   PUR: Make the URL apart from base URL.
   PRE: None.
   RET: Saves the result inside 'resultString' class variable.
  */
  private void makeAPIUrl(){

    resultString = "?client_id="+API_CLIENT_ID
            +"&client_secret="+API_CLIENT_SECRET
            +"&v="+currentDate
            +"&ll="+latitude+","+longitude
            +"&query="+searchQuery;
  }// end
}// END

