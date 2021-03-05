import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
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
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(22.5692, 88.4489),
    zoom: 7,
  );
  var getlocation = GetCurrentLocation();
  var myLocation;
  Position _currentPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrLoc();
    getData();
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
            Positioned(
                left: 0.0,
                top: 0.0,
                right: 0.0,
                child: AppBar(
                  elevation: 0.1,
                  actions: [
                    IconButton(
                      onPressed: ()=>_signOut(),
                      icon: Icon(Icons.logout, color: Colors.red,size: 33.0,),
                    ),
                  ],
                  title: Text("Micelio"),
                  backgroundColor: Colors.transparent,
                )),
          ],
        )
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Constants.prefs.setBool("loggedIn", false);
    Navigator.pushReplacementNamed(context, '/');
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _controller.complete(controller);
  }

  Future getCurrLoc() async{
    await getlocation.getCurrentLocation();
    setState(() {
      _currentPosition = getlocation.currPosition;
    });
    print("Line81 ${_currentPosition}");
  }

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://192.168.43.102:7000/chargers"),
        headers: {"Accept": "application/json"});
        var chargerDetais = jsonDecode(response.body);
        print("chargerDetails $chargerDetais");
  }
}
