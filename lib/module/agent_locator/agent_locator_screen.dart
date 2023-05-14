import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../base/base_consumer_state.dart';
import '../../../ui/custom_widgets/custom_common_app_bar_widget.dart';
import '../../utils/Colors.dart';
import 'api/agent_locator_controller.dart';


class AgentLocatorScreen extends ConsumerStatefulWidget {
  const AgentLocatorScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AgentLocatorScreen> createState() => _AgentLocatorScreenState();
}

class _AgentLocatorScreenState extends BaseConsumerState<AgentLocatorScreen> {

  GoogleMapController? mapController;
  LatLng? _currentLocation;
  Map<MarkerId, Marker> allMarkersMap = {};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.6850, 90.3563),
    zoom: 10,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCurrentLocation();
      _getBytesFromAsset();
    });
  }



  void _getCurrentLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    if (mapController != null && _currentLocation != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          _currentLocation!,
          15,
        ),
      );
    }
  }


  Future<Uint8List?> _getBytesFromAsset() async {
    try {
      ByteData data = await rootBundle.load("assets/images/ic_agent_locator.png");
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: 70, targetWidth: 50);
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
          ?.buffer
          .asUint8List();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    final agentData = ref.watch(agentLocatorControllerProvider);
    final marker2 = agentData.value?.locatorItems ?? [];

    for (var location in marker2) {
      _getBytesFromAsset().then((value) {
        var marker = Marker(
          markerId: MarkerId("${location.agentWalletNo}"),
          position: LatLng(location.latitude ?? 0, location.longitude ?? 0),
          infoWindow: InfoWindow(title: '${location.agentName}'),
          icon: BitmapDescriptor.fromBytes(value!),
        );
        allMarkersMap[marker.markerId] = marker;
      });
    }

    return Scaffold(
        appBar: const CustomCommonAppBarWidget(appBarTitle: 'Agent Locator'),
        backgroundColor: commonBackgroundColor,
        body: GoogleMap(
          initialCameraPosition: _initialPosition,
          mapType: MapType.normal,
          markers: Set<Marker>.of(allMarkersMap.values),
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          myLocationEnabled: true,
        ),
    );
  }

}