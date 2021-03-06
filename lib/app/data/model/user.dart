class UserInfoModel {
  final String firstName;
  final String lastName;
  final int favouriteNumber;

  UserInfoModel({
    this.firstName,
    this.lastName,
    this.favouriteNumber,
  });

  static fromMap(Map<String, dynamic> data) {
    return UserInfoModel(
      firstName: data['firstName'] as String,
      lastName: data['lastName'] as String,
      favouriteNumber: data['favouriteNumber'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'favouriteNumber': favouriteNumber,
  };
}
