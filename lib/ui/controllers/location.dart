import 'package:f_gps_tracker/domain/models/location.dart';
import 'package:f_gps_tracker/domain/use_cases/location_manager.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  final Rx<List<TrackedLocation>> _locations = Rx([]);

  List<TrackedLocation> get locations => _locations.value;

  Future<void> initialize() async {
    await LocationManager.initialize();
  }

  Future<void> saveLocation({
    required TrackedLocation location,
  }) async {
    LocationManager.save(location: location);
    _locations.update((val) {
      _locations.value.add(location);
    });
  }

  Future<List<TrackedLocation>> getAll({
    String? orderBy,
  }) async {
    _locations.value = await LocationManager.getAll();
    return _locations.value;
  }

  Future<void> updateLocation({required TrackedLocation location}) async {
    await LocationManager.update(location: location);
  }

  Future<void> deleteLocation({required TrackedLocation location}) async {
    await LocationManager.delete(location: location);
    _locations.update((element) {
      _locations.value.removeWhere((element) => element == location);
    });
  }

  Future<void> deleteAll() async {
    LocationManager.deleteAll();
    _locations.value = [];
  }
}
