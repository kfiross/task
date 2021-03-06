import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsService extends ChangeNotifier{
  bool _isLocationOn;
  bool _isNotificationOn;

  bool get isLocationOn => _isLocationOn;
  bool get isNotificationOn => _isNotificationOn;

  PermissionsService()
    :_isLocationOn = false,
     _isNotificationOn = false;

  void requestLocationPermission()async{
    var locationReq =  await Permission.location.request();
    _isLocationOn = locationReq.isGranted;
    notifyListeners();
  }

  void requestNotificationPermission()async{
    var notificationReq =  await Permission.notification.request();
    _isNotificationOn = notificationReq.isGranted;
    notifyListeners();
  }
}