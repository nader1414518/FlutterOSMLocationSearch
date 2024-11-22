import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class PickupMapWidget extends StatefulWidget {
  @override
  PickupMapWidgetState createState() => PickupMapWidgetState();
}

class PickupMapWidgetState extends State<PickupMapWidget> {
  final controller = MapController.withUserPosition(
    trackUserLocation: const UserTrackingOption(
      enableTracking: false,
      unFollowUser: false,
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Pick Up Location",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          TypeAheadField<SearchInfo>(
            suggestionsCallback: (search) => addressSuggestion(
              search,
              // locale: "ar-EG",
            ),
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        15,
                      ),
                    ),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.all(
                    10,
                  ),
                  labelText: 'Address',
                ),
              );
            },
            itemBuilder: (context, address) {
              return ListTile(
                title: Text(address.address!.name!),
                subtitle: Text(
                  address.address!.country!,
                ),
              );
            },
            onSelected: (address) async {
              // print(address.address!.name);
              await controller.moveTo(
                address.point!,
                animate: true,
              );

              await controller.addMarker(
                address.point!,
                markerIcon: const MarkerIcon(
                  icon: Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                // angle: pi / 3,
                // anchor: IconAnchor(
                //   anchor: Anchor.top,
                // ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: Stack(
              children: [
                OSMFlutter(
                  controller: controller,
                  osmOption: OSMOption(
                    userTrackingOption: const UserTrackingOption(
                      enableTracking: false,
                      unFollowUser: false,
                    ),
                    zoomOption: const ZoomOption(
                      initZoom: 8,
                      minZoomLevel: 3,
                      maxZoomLevel: 19,
                      stepZoom: 1.0,
                    ),
                    userLocationMarker: UserLocationMaker(
                      personMarker: const MarkerIcon(
                        icon: Icon(
                          Icons.location_history_rounded,
                          color: Colors.red,
                          size: 48,
                        ),
                      ),
                      directionArrowMarker: const MarkerIcon(
                        icon: Icon(
                          Icons.double_arrow,
                          size: 48,
                        ),
                      ),
                    ),
                    roadConfiguration: const RoadOption(
                      roadColor: Colors.yellowAccent,
                    ),
                    // markerOption: MarkerOption(
                    //   defaultMarker: MarkerIcon(
                    //     icon: Icon(
                    //       Icons.person_pin_circle,
                    //       color: Colors.blue,
                    //       size: 56,
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          5,
                        ),
                        child: InkWell(
                          onTap: () async {
                            await controller.zoomIn();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(
                          5,
                        ),
                        child: InkWell(
                          onTap: () async {
                            await controller.zoomOut();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.remove,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
