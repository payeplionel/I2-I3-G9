import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapOverview extends StatelessWidget {
  MapOverview({Key? key, required this.currentPosition}) : super(key: key);
  Position? currentPosition;

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  List<Marker> rideMarkers = [
    const Marker(
      markerId: MarkerId('marker1'),
      position: LatLng(37.7749, -122.4194),
      infoWindow: InfoWindow(
        title: 'San Francisco',
        snippet: 'A beautiful city',
      ),
    ),
    // Ajoutez d'autres marqueurs ici...
  ];

  @override
  Widget build(BuildContext context) {
    if (currentPosition == null) {
      return Container(); // Ne rien afficher si currentPosition est null
    }

    final CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(
        currentPosition!.latitude,
        currentPosition!.longitude,
      ),
      zoom: 14.4746,
    );

    return Visibility(
      visible: currentPosition != null,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: kGooglePlex,
        onMapCreated: (GoogleMapController controller) async {
          String style = await DefaultAssetBundle.of(context)
              .loadString('assets/map_style.json');
          controller.setMapStyle(style);
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(rideMarkers),
      ),
    );
  }
}
