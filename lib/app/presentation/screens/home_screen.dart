import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocation/geolocation.dart';
import 'package:provider/provider.dart';
import 'package:pumba_task/app/data/model/user.dart';
import 'package:pumba_task/app/data/repository/user_repository_impl.dart';
import 'package:pumba_task/app/presentation/state/auth_service.dart';
import 'package:pumba_task/app/presentation/state/permission_service.dart';
import 'package:pumba_task/core/utils/location_utils.dart';
import 'package:pumba_task/core/utils/notification_utils.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserInfoModel _user;

  @override
  Widget build(BuildContext context) {
    final repo = UserRepositoryImpl();

    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Container(
          child: FutureBuilder(
            future: repo.getUserInfo(FirebaseAuth.instance.currentUser.uid),
            builder:
                (BuildContext context, AsyncSnapshot<UserInfoModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return Container(child: Text("Error"));
                }
                _user = snapshot.data;
                return _buildData(context, snapshot.data);
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            child: ElevatedButton(
              child: Text("Logout"),
              onPressed: () => _logout(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildData(BuildContext context, UserInfoModel userInfo) {
    var permissionsService = Provider.of<PermissionsService>(context, listen: true);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              "Hello ${userInfo.firstName} ${userInfo.lastName}, how are you today?"),
          const SizedBox(height: 24),
          permissionsService.isLocationOn
              ? FutureBuilder<LocationResult>(
            future: LocationUtils.getCurrentLocation(),
            builder: (context, AsyncSnapshot<LocationResult> snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                return Text("Your location is ${snapshot.data.location}");
              }
              return Text(" ");
            },

          )
              : Container(
                  width: 200,
                  child: ElevatedButton(
                    child: Text("Allow location"),
                    onPressed: () => _requestLocation(context),
                  ),
                ),
          const SizedBox(height: 4),
          Container(
            width: 200,
            child: ElevatedButton(
              child: Text("Start"),
              onPressed: () => _requestNotification(context),
            ),
          ),
        ],
      ),
    );
  }

  void _requestLocation(BuildContext context) {
    var permissionsService = Provider.of<PermissionsService>(context, listen: false);
    // invoke permission location
    permissionsService.requestLocationPermission();
  }

  /// shows notification after x minutes
  void _requestNotification(BuildContext context) {
    var permissionsService =
        Provider.of<PermissionsService>(context, listen: false);

    // invoke permission check
    permissionsService.requestNotificationPermission();

    // if permission granted, so notification after the time settd
    Future.delayed(Duration(minutes: _user.favouriteNumber)).then((_) {
      // show (local) notification
      NotificationUtils().showNotification();
    });
  }

  void _logout(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.logout();
  }
}
