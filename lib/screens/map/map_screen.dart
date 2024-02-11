import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handyman_admin_flutter/components/app_widgets.dart';
import 'package:handyman_admin_flutter/components/back_widget.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/utils/common.dart';
import 'package:handyman_admin_flutter/utils/location_service.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/colors.dart';

class MapScreen extends StatefulWidget {
  final double longitude;
  final double latitude;

  MapScreen({this.longitude = 0, this.latitude = 0});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController? mapController;

  String _currentAddress = '';
  LatLng selectedLatLong = LatLng(0, 0);

  final destinationAddressController = TextEditingController();
  final destinationAddressFocusNode = FocusNode();

  String _destinationAddress = '';

  Set<Marker> markers = {};

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getServiceLocationPosition();
    /*afterBuildCreated(() {
      _getCurrentLocation();
    });*/
  }

  // Method for retrieving the current location
  void _getCurrentLocation() async {
    appStore.setLoading(true);

    await getServiceLocationPosition().then((position) async {
      setAddress();
      selectedLatLong = LatLng(position.latitude, position.longitude);

      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 18.0),
        ),
      );

      markers.clear();
      markers.add(Marker(
        markerId: MarkerId(_currentAddress),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: 'Start $_currentAddress', snippet: _destinationAddress),
        icon: BitmapDescriptor.defaultMarker,
      ));

      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  // Method for retrieving the address
  Future<void> setAddress() async {
    try {
      Position position = await getServiceLocationPosition().catchError((e) {
        //
      });

      List<Placemark> p = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = p[0];

      _currentAddress = "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
      destinationAddressController.text = _currentAddress;
      _destinationAddress = _currentAddress;

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  _handleTap(LatLng point) async {
    selectedLatLong = point;
    appStore.setLoading(true);

    markers.clear();
    markers.add(Marker(
      markerId: MarkerId(point.toString()),
      position: point,
      infoWindow: InfoWindow(),
      icon: BitmapDescriptor.defaultMarker,
    ));

    destinationAddressController.text = await buildFullAddressFromLatLong(point.latitude, point.longitude).catchError((e) {
      log(e);
    });

    _destinationAddress = destinationAddressController.text;

    appStore.setLoading(false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget(locale.getLocation, backWidget: BackWidget(), color: primaryColor, elevation: 0, textColor: white),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: Set<Marker>.from(markers),
            initialCameraPosition: _initialLocation,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;

              _getCurrentLocation();
            },
            onTap: _handleTap,
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: Material(
                    color: Colors.blue.shade100,
                    child: InkWell(
                      splashColor: context.primaryColor.withOpacity(0.8),
                      child: SizedBox(width: 50, height: 50, child: Icon(Icons.add)),
                      onTap: () {
                        mapController!.animateCamera(CameraUpdate.zoomIn());
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ClipOval(
                  child: Material(
                    color: Colors.blue.shade100,
                    child: InkWell(
                      splashColor: context.primaryColor.withOpacity(0.8),
                      child: SizedBox(width: 50, height: 50, child: Icon(Icons.remove)),
                      onTap: () {
                        mapController!.animateCamera(CameraUpdate.zoomOut());
                      },
                    ),
                  ),
                ),
              ],
            ).paddingLeft(10),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipOval(
                  child: Material(
                    color: Colors.orange.shade100, // button color
                    child: Icon(Icons.my_location, size: 25).paddingAll(10),
                  ),
                ).paddingRight(8).onTap(() async {
                  appStore.setLoading(true);

                  await getServiceLocationPosition().then((value) {
                    mapController!.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(target: LatLng(value.latitude, value.longitude), zoom: 18.0),
                      ),
                    );

                    _handleTap(LatLng(value.latitude, value.longitude));
                  }).catchError(onError);

                  appStore.setLoading(false);
                }),
                8.height,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AppTextField(
                      textFieldType: TextFieldType.MULTILINE,
                      controller: destinationAddressController,
                      focus: destinationAddressFocusNode,
                      textStyle: primaryTextStyle(),
                      decoration: inputDecoration(context, hint: locale.address).copyWith(fillColor: Colors.white70),
                    ),
                  ],
                ),
                8.height,
                AppButton(
                  width: context.width(),
                  color: primaryColor.withOpacity(0.8),
                  text: locale.setAddress,
                  onTap: () {
                    if (destinationAddressController.text.isNotEmpty) {
                      Map map = {
                        'lat': selectedLatLong.latitude,
                        'long': selectedLatLong.longitude,
                        'address': destinationAddressController.text,
                      };
                      finish(context, map);
                    } else {
                      toast(locale.pickAddress);
                    }
                  },
                ),
                8.height,
              ],
            ).paddingAll(16),
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
