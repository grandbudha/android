package com.example.mobilly;

import android.Manifest;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;

/*
 Class to get the current location longitude and latitude using GPS or network setting.
 */
public class GetLocation extends Service implements LocationListener {

    /* One minute time to update */
    private static final int ONE_MINUTE = (1000*60);

    /* Minimum distance to update the coordinates, 10 meter */
    private static final int DISTANCE = 10;

    /* Current activity context reference variable */
    private Context context;

    /* Flag to check if the GPS setting is enabled or not */
    boolean isGPSEnable;

    /* Flag to check if the Network setting is enabled or not */
    boolean isNetworkEnabled;

    /* Flag if it is possible to get the current location using LocationManager */
    boolean isCurrentLocation;

    /* Reference variable to store current location details */
    Location location;

    /* Stores the current location latitude */
    double latitude;

    /* Stores the current location longitude */
    double longitude;

    /* Minimum distance to update the current location coordinates */
    private static final long MIN_DISTANCE_FOR_UPDATE = DISTANCE;

    /* Minimum time period to update the current location coordinates */
    private static final long MIN_TIME_FOR_UPDATE = ONE_MINUTE;

    /* Saves the name of permission which we require to get user location */
    String fineLocationPermission = Manifest.permission.ACCESS_FINE_LOCATION;

    /* Reference variable for LocationManager class */
    LocationManager locationManager;

    /* Counter to count how many times we have initiated the getCurrentLocation method */
    boolean counter;

    /* Constructor */
    GetLocation(Context context){
        this.context = context;
        isGPSEnable = false;
        isNetworkEnabled = false;
        isCurrentLocation = false;
        counter = false;
        latitude = 0.0;
        longitude = 0.0;

        /* Get the current location */
        getCurrentLocation();
    }// end

    /*
     PUR: Get the current location of the user uding LocationManager.
     PRE: None.
     RET: Returns the current location, in case of failure returns null.
    */
    public Location getCurrentLocation(){

        try {

            /* Get object reference for location manager */
            locationManager = (LocationManager) context.getSystemService(LOCATION_SERVICE);

            /* Check if the GPS is enabled or not */
            isGPSEnable = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);

            /* Check for the network status */
            isNetworkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);

            /* If settings are disabled then enable them */
            if (!isGPSEnable && !isNetworkEnabled){

                /* Intent to start GPS settings */
                Intent intent = new Intent(android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                context.startActivity(intent);

                /* If this is the first time then do the recursion */
                if(!counter){

                    /* Call the method again to check settings */
                    getCurrentLocation();
                    counter = true;
                }
                /* Ignore and return null */
                else {
                    return null;
                }
            }
            /* If settings are enable get the current location coordinates */
            else {

                /* Set the flags */
                this.isCurrentLocation = true;

                /* Get the location from GPS provider */
                if(Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP_MR1){

                    /* If user has still not provided the permission or its been revoked then return null */
                    if(context.checkSelfPermission(fineLocationPermission) != PackageManager.PERMISSION_GRANTED){
                        this.isCurrentLocation = false;
                        return null;
                    }
                    /* Check for the appropriate setting for Location manager */
                    else {

                        /* If GPS is enabled then use GPS settings */
                        if(isGPSEnable) {
                            locationManager.requestLocationUpdates(
                                    LocationManager.GPS_PROVIDER,
                                    MIN_TIME_FOR_UPDATE,
                                    MIN_DISTANCE_FOR_UPDATE,
                                    this
                            );
                        }
                        /* If network is enabled then use network settings */
                        else if(isNetworkEnabled) {
                            locationManager.requestLocationUpdates(
                                    LocationManager.NETWORK_PROVIDER,
                                    MIN_TIME_FOR_UPDATE,
                                    MIN_DISTANCE_FOR_UPDATE,
                                    this
                            );
                        }
                    }
                }

                /* Get the last known location */
                if(locationManager != null){
                    location = locationManager.getLastKnownLocation(
                            (isGPSEnable)?LocationManager.GPS_PROVIDER:LocationManager.NETWORK_PROVIDER);
                }

                /* Get the longitude and latitude values */
                if(location != null){
                    latitude = location.getLatitude();
                    longitude = location.getLongitude();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return location;
    }// end

    /*
     PUR: Getter method of Longitude.
     PRE: Location must not be null, if it is null then get the location.
     RET: Returns the longitude value of current location.
    */
    public double getLongitude(){
        if(location != null)
            return location.getLongitude();
        else {
            Location location = getCurrentLocation();
            return location.getLongitude();
        }
    }// end

    /*
    PUR: Getter method of Latitude.
    PRE: Location must not be null, if it is null then get the location.
    RET: Returns the latitude value of current location.
    */
    public double getLatitude(){
        if(location != null)
            return location.getLatitude();
        else {
            Location location = getCurrentLocation();
            return location.getLatitude();
        }
    }// end

    /*
    PUR: Get the current location flag.
    PRE: None.
    RET:  Returns the current location flag.
    */
    public boolean getIsCurrentLocation(){
        return this.isCurrentLocation;
    }// end


    /* Override methods */
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }// end

    @Override
    public void onLocationChanged(Location location) {

    }// end

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {

    }// end

    @Override
    public void onProviderEnabled(String provider) {

    }// end

    @Override
    public void onProviderDisabled(String provider) {

    }// end
}// END
