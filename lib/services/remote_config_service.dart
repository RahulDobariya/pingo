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
      'country_code': 'us', 
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
