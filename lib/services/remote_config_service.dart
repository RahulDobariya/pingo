// import 'package:firebase_remote_config/firebase_remote_config.dart';

// class RemoteConfigService {
//   final FirebaseRemoteConfig remoteConfig;

//   RemoteConfigService({required this.remoteConfig});

//   Future<void> initialize() async {
//     await remoteConfig.setConfigSettings(RemoteConfigSettings(
//       fetchTimeout: const Duration(minutes: 1),
//       minimumFetchInterval: const Duration(hours: 1),
//     ));
//     await fetchAndActivate();
//   }

//   Future<void> fetchAndActivate() async {
//     await remoteConfig.fetchAndActivate();
//   }

//   String getCountryCode() {
//     return remoteConfig.getString('country_code');
//   }
// }

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService._(this._remoteConfig);

  static Future<RemoteConfigService> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(hours: 1),
      ),
    );

    await remoteConfig.setDefaults({
      'country_code': 'us', // Default value for country code
    });

    try {
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      print('RemoteConfig fetch failed: $e');
    }

    return RemoteConfigService._(remoteConfig);
  }

  static RemoteConfigService defaultService() {
    final remoteConfig = FirebaseRemoteConfig.instance;
    return RemoteConfigService._(remoteConfig);
  }

  String getCountryCode() {
    return _remoteConfig.getString('country_code');
  }
}
