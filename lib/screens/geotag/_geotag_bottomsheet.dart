import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pcic_mobile_app/theme/_theme.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class GeoTagBottomSheet extends StatefulWidget {
  final String latitude;
  final String longitude;
  final bool isRoutingStarted;

  final VoidCallback onStopRoutingRequest;
  final VoidCallback onStartRoutingRequest;
  final VoidCallback onAddMarkerCurrentLocationRequest;

  final ScrollController controller;
  final PanelController panelController;

  const GeoTagBottomSheet(
      {super.key,
      required this.controller,
      required this.isRoutingStarted,
      required this.onStopRoutingRequest,
      required this.onStartRoutingRequest,
      required this.onAddMarkerCurrentLocationRequest,
      required this.latitude,
      required this.longitude,
      required this.panelController});

  @override
  State<GeoTagBottomSheet> createState() => _GeoTagBottomSheetState();
}

class _GeoTagBottomSheetState extends State<GeoTagBottomSheet> {
  void togglePanel() => widget.panelController.isPanelOpen
      ? widget.panelController.close()
      : widget.panelController.open();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<CustomThemeExtension>()!;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: togglePanel,
            child: Center(
              child: Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: const Color(0xFF0F7D40),
                      borderRadius: BorderRadius.circular(30.0))),
            ),
          ),
          Text(
            'Route Points',
            style: TextStyle(fontSize: t.title, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  ElevatedButton(
                      onPressed: widget.isRoutingStarted
                          ? null
                          : widget.onStartRoutingRequest,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 60),
                        shape: const CircleBorder(),
                        backgroundColor: widget.isRoutingStarted
                            ? null
                            : const Color(0xFF0F7D40),
                      ),
                      child: SizedBox(
                          height: 35,
                          width: 35,
                          child: SvgPicture.asset(
                            'assets/storage/images/start.svg',
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ))),
                  Text(
                    'Start',
                    style: TextStyle(
                        fontSize: t.caption,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                      onPressed: widget.isRoutingStarted
                          ? () {
                              widget.onAddMarkerCurrentLocationRequest();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 60),
                        shape: const CircleBorder(),
                        backgroundColor: widget.isRoutingStarted
                            ? const Color(0xFF0F7D40)
                            : Colors.white60,
                      ),
                      child: SizedBox(
                          height: 35,
                          width: 35,
                          child: SvgPicture.asset(
                            'assets/storage/images/pindrop.svg',
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ))),
                  Text(
                    'Pin Drop',
                    style: TextStyle(
                        fontSize: t.caption,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                      onPressed: widget.isRoutingStarted
                          ? widget.onStopRoutingRequest
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 60),
                        shape: const CircleBorder(),
                        backgroundColor: widget.isRoutingStarted
                            ? const Color(0xFF0F7D40)
                            : Colors.white60,
                      ),
                      child: SizedBox(
                          height: 35,
                          width: 35,
                          child: SvgPicture.asset(
                            'assets/storage/images/stop.svg',
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ))),
                  Text(
                    'Stop',
                    style: TextStyle(
                        fontSize: t.caption,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          const Divider(
            color: Color(0xFF0F7D40),
          ),
          Text(
            'Location',
            style: TextStyle(fontSize: t.title, fontWeight: FontWeight.bold),
          ),
          // Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          //   SizedBox(
          //     height: 35,
          //     width: 35,
          //     child: SvgPicture.asset(
          //       'assets/storage/images/navigate.svg',
          //       colorFilter:
          //           const ColorFilter.mode(Color(0xFF0F7D40), BlendMode.srcIn),
          //     ),
          //   ),
          //   const SizedBox(
          //     width: 8.0,
          //   ),
          //   const Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         'Address',
          //         style: TextStyle(
          //             fontSize: 11.11,
          //             fontWeight: FontWeight.w700,
          //             color: Color(0xFF797C7B)),
          //       ),
          //       Text('Legazpi City, Albay, 4500',
          //           style: TextStyle(
          //               fontSize: t.caption,
          //               fontWeight: FontWeight.bold,
          //               color: Colors.black))
          //     ],
          //   )
          // ]),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: 35,
              width: 35,
              child: SvgPicture.asset(
                'assets/storage/images/map.svg',
                colorFilter:
                    const ColorFilter.mode(Color(0xFF0F7D40), BlendMode.srcIn),
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coordinates',
                  style: TextStyle(
                    fontSize: t.overline,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F7D40),
                  ),
                ),
                Text('Latitude: ${widget.latitude}',
                    style: TextStyle(
                        fontSize: t.caption,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text('Longitude: ${widget.longitude}',
                    // Or clip, fade,
                    style: TextStyle(
                        fontSize: t.caption,
                        fontWeight: FontWeight.bold,
                        color: Colors.black))
              ],
            )
          ])
        ],
      ),
    );
  }
}
