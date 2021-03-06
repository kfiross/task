import 'package:pumba_task/app/data/model/user.dart';

abstract class UserRepository{
  Future<UserInfoModel> getUserInfo(String uid);
  Future<void> createUserInfo(UserInfoModel newUser);
}