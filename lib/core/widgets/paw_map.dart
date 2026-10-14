import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/tokens.dart';

/// OpenStreetMap via flutter_map, used by walks, the clinic finder, SOS,
/// lost pet and devices. Follows the OSM tile usage policy: a real user
/// agent, cached tiles and visible attribution.
class PawMap extends StatelessWidget {
  const PawMap({
    super.key,
    required this.center,
    this.zoom = 15,
    this.routes = const [],
    this.markers = const [],
    this.circles = const [],
    this.interactive = true,
    this.controller,
    this.fitPoints,
  });

  final LatLng center;
  final double zoom;
  final List<List<LatLng>> routes;
  final List<Marker> markers;
  final List<CircleMarker> circles;
  final bool interactive;
  final MapController? controller;

  /// When set, the camera fits these points.
  final List<LatLng>? fitPoints;

  static const tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  @override
  Widget build(BuildContext context) {
    final fit = fitPoints != null && fitPoints!.length > 1
        ? CameraFit.coordinates(coordinates: fitPoints!, padding: const EdgeInsets.all(32))
        : null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.card),
      child: FlutterMap(
        mapController: controller,
        options: MapOptions(
          initialCenter: center,
          initialZoom: zoom,
          initialCameraFit: fit,
          interactionOptions: InteractionOptions(
            flags: interactive ? InteractiveFlag.all & ~InteractiveFlag.rotate : InteractiveFlag.none,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: tileUrl,
            userAgentPackageName: 'com.pawsetu.app',
            maxZoom: 19,
          ),
          if (circles.isNotEmpty) CircleLayer(circles: circles),
          if (routes.isNotEmpty)
            PolylineLayer(polylines: [
              for (final r in routes)
                Polyline(points: r, strokeWidth: 5, color: context.colors.primary, borderStrokeWidth: 2, borderColor: Colors.white),
            ]),
          if (markers.isNotEmpty) MarkerLayer(markers: markers),
          RichAttributionWidget(
            alignment: AttributionAlignment.bottomLeft,
            showFlutterMapAttribution: false,
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launchUrl(Uri.parse('https://www.openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Round pin used on maps.
Marker pinMarker(LatLng p, {required Color color, IconData icon = Icons.place_rounded, double size = 40, String? label}) => Marker(
      point: p,
      width: size,
      height: size,
      child: Semantics(
        label: label,
        child: Icon(icon, color: color, size: size, shadows: const [Shadow(blurRadius: 4, color: Colors.black26)]),
      ),
    );

Marker dotMarker(LatLng p, Color color) => Marker(
      point: p,
      width: 22,
      height: 22,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
        ),
      ),
    );

/// Opens the phone's maps app for directions (no paid routing API).
Future<void> openDirections(double lat, double lng, {String? label}) async {
  final q = label == null ? '$lat,$lng' : '$lat,$lng(${Uri.encodeComponent(label)})';
  final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
  final geo = Uri.parse('geo:$lat,$lng?q=$q');
  if (await canLaunchUrl(geo)) {
    await launchUrl(geo);
  } else {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
