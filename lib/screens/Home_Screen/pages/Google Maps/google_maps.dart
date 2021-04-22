import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:instant_tasker/widgets/customAppBar.dart';

class Mapss extends StatefulWidget {
  final Position position;
  final double desLat;
  final double desLng;
  Mapss(
      {@required this.position, @required this.desLat, @required this.desLng});
  @override
  _MapssState createState() => _MapssState();
}

class _MapssState extends State<Mapss> {
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Set<Marker> _markers = {};

  addMarker() {
    _markers.add(Marker(
        infoWindow: InfoWindow(title: 'You'),
        markerId: MarkerId('sourcePin'),
        position: LatLng(widget.position.latitude, widget.position.longitude),
        icon: BitmapDescriptor.defaultMarker));

    _markers.add(Marker(
        infoWindow: InfoWindow(title: 'Destination'),
        markerId: MarkerId('desPin'),
        position: LatLng(widget.desLat, widget.desLng),
        icon: BitmapDescriptor.defaultMarker));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      addMarker();
    });
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(widget.position.latitude, widget.position.longitude),
            zoom: 8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Maps'),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _initialcameraposition),
        mapType: MapType.hybrid,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        markers: _markers,
      ),
    );
  }
}
