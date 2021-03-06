import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:micelio/utils/constants.dart';
import 'package:micelio/utils/getcurrentlocation.dart';
import 'package:micelio/utils/onWillPop.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  BitmapDescriptor userLocIcon;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(22.5692, 88.4489),
    zoom: 7,
  );
  var getLocation = GetCurrentLocation();
  List nearbyCharger;
  List allMarker = [];
  Position _currentPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomMapPin();
    getCurrLoc();
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: OnWillPop().onWillPop,
      child: Scaffold(
          body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: _onMapCreated,
            trafficEnabled: true,
            // myLocationEnabled: true,
            // myLocationButtonEnabled: true,
            markers: Set<Marker>.of(markers.values),
          ),
          (nearbyCharger != null)
              ? Positioned(
                  left: 0.0,
                  bottom: 0.0,
                  right: 0.0,
                  child: Container(
                    height: screenSize.height * 0.25,
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: nearbyCharger.length,
                        itemBuilder: (BuildContext context, int index) => Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        'assets/images/download.png',
                                        width: screenSize.width * 0.2,
                                        height: screenSize.height * 0.05,
                                      ),
                                      SizedBox(width: screenSize.width * 0.05),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (nearbyCharger[index]['charger_id'] !=
                                                  null)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 6.0),
                                                  child: Text(
                                                    nearbyCharger[index]
                                                        ['charger_id'],
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                )
                                              : Container(),
                                          (nearbyCharger[index]
                                                      ['charger_name'] !=
                                                  null)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 6.0),
                                                  child: Text(
                                                    nearbyCharger[index]
                                                            ['charger_name']
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16.0),
                                                  ),
                                                )
                                              : Container(),
                                          (nearbyCharger[index]
                                                      ['chargerStatus'] !=
                                                  null)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 6.0),
                                                  child: Text(
                                                    nearbyCharger[index]
                                                        ['chargerStatus'],
                                                    style: TextStyle(
                                                        color: (nearbyCharger[
                                                                        index][
                                                                    'chargerStatus'] ==
                                                                'available')
                                                            ? Colors.green
                                                            : (nearbyCharger[
                                                                            index]
                                                                        [
                                                                        'chargerStatus'] ==
                                                                    'unavailable')
                                                                ? Colors.red
                                                                : Colors.black),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                      width: screenSize.width * 0.7,
                                      child: RaisedButton(
                                        onPressed: () {},
                                        color: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          // side: BorderSide(color: Colors.red)
                                        ),
                                        child: Text(
                                          "BOOK NOW",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          Positioned(
              left: 0.0,
              top: screenSize.height * 0.07,
              right: 0.0,
              child: Container(
                height: screenSize.height * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => _signOut(),
                      icon: Icon(
                        Icons.logout,
                        color: Colors.black,
                        size: 32.0,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Theme(
                            data: ThemeData(
                                primaryColor: Colors.green,
                                hintColor: Colors.grey),
                            child: TextField(
                              decoration: new InputDecoration(
                                  // borderRadiuserSide: const BorderSide(color: Colors.grey, width: 0.0),
                                  border: new OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 0.0),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(50.0),
                                    ),
                                  ),
                                  filled: true,
                                  prefixIcon: Icon(Icons.circle,
                                      color: Colors.green, size: 11.0),
                                  hintText: "Your Location",
                                  fillColor: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 4.0, right: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: IconButton(
                        onPressed: () => getCurrLoc(),
                        icon: Icon(
                          Icons.my_location_rounded,
                          color: Colors.black,
                          size: 32.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      )),
    );
  }

  Future<void> _signOut() async {
    await Firebase.initializeApp();
    if (!mounted) return;
    await FirebaseAuth.instance.signOut();
    Constants.prefs.setBool("loggedIn", false);
    Navigator.pushReplacementNamed(context, '/');
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _controller.complete(controller);
  }

  Future getCurrLoc() async {
    await getLocation.getCurrentLocation();
    setState(() {
      _currentPosition = getLocation.currPosition;
      allMarker.add({_currentPosition});
    });
    markerC(_currentPosition);
    getNearbyCharger(_currentPosition);
  }

  Future getNearbyCharger(Position position) async {
    final uri = "https://micelio.herokuapp.com/chargers/nearcharger";
    final headers = {'Content-Type': 'application/json'};
    var body = {
      "location": {
        "type": "Point",
        "coordinates": [position.latitude, position.longitude]
      }
    };
    final jsonBody = jsonEncode(body);
    http.post(uri, body: jsonBody, headers: headers).then((response) {
      final body1 = json.decode(response.body);
      setState(() {
        nearbyCharger = body1;
      });
    });
  }

  Future markerC(Position positions) async {
    markers.clear();
    // creating a new MARKER
    var markerIdVal = markers.length + 1;
    String mar = markerIdVal.toString();
    final MarkerId markerId = MarkerId(mar);
    final Marker marker = Marker(
        markerId: markerId,
        infoWindow: InfoWindow(
              title: positions.toString()),
        position: LatLng(positions.latitude,positions.longitude),
        icon: userLocIcon);
    setState(() {
      markers[markerId] = marker;
    });
  }

  void setCustomMapPin() async {
    BitmapDescriptor chargerLocation = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5, size: Size(20, 20)),
        'assets/images/marker.png');
    setState(() {
      userLocIcon = chargerLocation;
    });
  }
}
