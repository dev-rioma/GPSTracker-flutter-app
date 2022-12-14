import 'package:f_gps_tracker/domain/models/location.dart';
import 'package:f_gps_tracker/ui/controllers/gps.dart';
import 'package:f_gps_tracker/ui/controllers/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy_status.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ContentPage extends GetView<LocationController> {
  late final GpsController gpsController = Get.find();

  ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("GPS Tracker"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: controller.getAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        Position ubicacion =
                            await gpsController.currentLocation;

                        LocationAccuracyStatus accurcy =
                            await gpsController.locationAccuracy;

                        TrackedLocation location = TrackedLocation(
                            latitude: ubicacion.latitude,
                            longitude: ubicacion.longitude,
                            precision: accurcy.name,
                            timestamp: DateTime.now());

                        controller.saveLocation(location: location);
                      },
                      child: const Text("Registrar Ubicacion"),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => ListView.separated(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: controller.locations.length,
                        itemBuilder: (context, index) {
                          final location = controller.locations[index];
                          return Card( 
                            color: Color.fromARGB(255, 233, 181, 255),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              isThreeLine: true,
                              leading: Icon(
                                Icons.gps_fixed_rounded,
                                color: Colors.amber[300],
                              ),
                              title: Text(
                                  '${location.latitude}, ${location.longitude}'),
                              subtitle: Text(
                                  'Fecha: ${location.timestamp.toIso8601String()}\n${location.precision.toUpperCase()}'),
                              trailing: IconButton(
                                onPressed: () {
                                  controller.deleteLocation(location: location);
                                },
                                icon: const Icon(
                                  Icons.delete_forever_rounded,
                                  color: Color.fromARGB(255, 255, 221, 83),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        Alert(
                          title: "??????ATENCION!!!",
                          desc: "Esta seguro que desea eliminar todos los registros?",
                          type: AlertType.info,
                          buttons: [
                          DialogButton(
                            color: Colors.grey[600],
                            child: Text(style: TextStyle(color: Colors.white),"SI"), 
                            onPressed: () {
                              controller.deleteAll();
                              Navigator.pop(context);}),
                          DialogButton(
                            color: Colors.purple,
                            child: Text(style: TextStyle(color: Colors.white),"NO"), 
                            onPressed: () {
                              Navigator.pop(context);
                          })],
                        context: context)
                        .show();
                      },
                      child: const Text("Eliminar Todos"),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
