import 'package:flutter/material.dart';

enum RegisterMode {login, register} 

class SignInForm extends ChangeNotifier {
  RegisterMode _mode;
  
  String firstName;
  String lastName;
  String email;
  String password;
  int favouriteNumber;

  SignInForm(){
    _mode = RegisterMode.login;
  }

  bool _isFormValid = false;
  bool get isFormValid => _isFormValid;

  void checkFormValidation() {
    bool isFormValid;
    try {
      if (mode == RegisterMode.login) {
        isFormValid = email.isNotEmpty && password.isNotEmpty;
      }
      else if (mode == RegisterMode.register) {
        isFormValid =
            email.isNotEmpty && password.isNotEmpty && firstName.isNotEmpty &&
                lastName.isNotEmpty;
      }
    }
    catch(_){
      isFormValid = false;
    }
    _isFormValid = isFormValid;
    notifyListeners();
  }


  RegisterMode get mode => _mode;

  // String get firstName => _firstName;
  // String get lastName => _lastName;
  // String get email => _email;
  // int get favouriteNumber => _favouriteNumber;
  //
  // set firstName(String val) => _firstName = val;
  // set lastName(String val) => _lastName = val;
  // set email(String val) => _email = val;
  // set favouriteNumber(String val) => _favouriteNumber = val;

  submitForm(){

  }
  
  void changeMode(){
    _mode = _mode == RegisterMode.login ? RegisterMode.register : RegisterMode.login;
    notifyListeners();
  }
}
