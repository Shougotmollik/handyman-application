import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

Future<Position> getServiceLocationPosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  LocationPermission permission = await Geolocator.checkPermission();
  if (!serviceEnabled) {
    //
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.openAppSettings();
      throw locale.locationPermissionsDenied;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw locale.locationPermissionsDeniedPermanently;
  }

  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) {
    return value;
  }).catchError((e) async {
    return await Geolocator.getLastKnownPosition().then((value) async {
      if (value != null) {
        return value;
      } else {
        throw locale.locationServicesEnabled;
      }
    }).catchError((e) {
      toast(e.toString());
    });
  });
}

Future<String> getUserLocation() async {
  Position position = await getServiceLocationPosition().catchError((e) {
    throw e.toString();
  });

  return await buildFullAddressFromLatLong(position.latitude, position.longitude);
}

Future<String> buildFullAddressFromLatLong(double latitude, double longitude) async {
  List<Placemark> placeMark = await placemarkFromCoordinates(latitude, longitude).catchError((e) async {
    log(e);
    throw errorSomethingWentWrong;
  });

  setValue(LATITUDE, latitude);
  setValue(LONGITUDE, longitude);

  Placemark place = placeMark[0];

  String address = '';

  if (!place.name.isEmptyOrNull && !place.street.isEmptyOrNull && place.name != place.street) address = '${place.name.validate()}, ';
  if (!place.street.isEmptyOrNull) address = '$address${place.street.validate()}';
  if (!place.locality.isEmptyOrNull) address = '$address, ${place.locality.validate()}';
  if (!place.administrativeArea.isEmptyOrNull) address = '$address, ${place.administrativeArea.validate()}';
  if (!place.postalCode.isEmptyOrNull) address = '$address, ${place.postalCode.validate()}';
  if (!place.country.isEmptyOrNull) address = '$address, ${place.country.validate()}';

  setValue(CURRENT_ADDRESS, address);

  return address;
}
