import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pumba_task/app/data/model/user.dart';
import 'package:pumba_task/app/domain/respository_api/user_repository.dart';

class UserRepositoryImpl extends UserRepository{
  @override
  Future<UserInfoModel> getUserInfo(String uid) async{
    final snapshot = await FirebaseFirestore.instance.doc("users/$uid").get();

    final user = UserInfoModel.fromMap(snapshot.data());
    return user;
  }

  @override
  Future<void> createUserInfo(UserInfoModel newUser) async{
   await FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid).set(newUser.toJson());
  }

}