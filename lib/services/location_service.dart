import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  late LocationData _locationData;

  Future<void> initialize() async {
    bool serviceEnabled;
    PermissionStatus permissionStatus;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }
  }
}
