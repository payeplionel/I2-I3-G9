import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapOverview extends StatelessWidget {
  MapOverview({Key? key}) : super(key: key);

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) async {
        String style = await DefaultAssetBundle.of(context).
        loadString('assets/map_style.json');
        controller.setMapStyle(style);
        _controller.complete(controller);
      },
    );
  }
}
