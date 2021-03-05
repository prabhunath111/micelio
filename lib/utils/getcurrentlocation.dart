import 'package:geolocator/geolocator.dart';
class GetCurrentLocation {
  Position currPosition;
  Future getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      print("position9, $position");
      currPosition=position;
    }).catchError((e) {
      print(e);
    });
  }
}