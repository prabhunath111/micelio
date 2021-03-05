import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:micelio/utils/constants.dart';
import 'package:micelio/utils/onWillPop.dart';

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
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: Set<Marker>.of(markers.values),
            ),
            Positioned(
              right: 0.0,
              top: screenSize.height*0.05,
              child: IconButton(
              onPressed: ()=>_signOut(),
              icon: Icon(Icons.logout, color: Colors.red,size: 33.0,),
            ),
            )
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
}
