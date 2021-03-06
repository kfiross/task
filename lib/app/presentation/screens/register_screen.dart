import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pumba_task/app/data/model/user.dart';
import 'package:pumba_task/app/data/repository/user_repository_impl.dart';
import 'package:pumba_task/app/presentation/state/auth_service.dart';
import 'package:pumba_task/app/presentation/state/sign_in_form.dart';

class RegisterScreen extends StatelessWidget{
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome")),
      body: Center(
        child: SingleChildScrollView(child: _form(context)),
      ),
    );
  }

  Widget _form(BuildContext context) {
    final signInForm = Provider.of<SignInForm>(context, listen: true);

    return signInForm.mode == RegisterMode.register
        ? _registerForm(context)
        : _loginForm(context);
  }

  Widget _registerForm(BuildContext context) {
    final signInForm = Provider.of<SignInForm>(context, listen: true);

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              onSaved: (val) => signInForm.firstName = val,
              onChanged: (val) {
                signInForm.firstName = val;
                checkIfValid(context);
              },
              decoration: InputDecoration(
                hintText: "First Name",
              ),
              validator: (val) {
                return val.isEmpty ? "Field is required" : null;
              },
            ),
            TextFormField(
              onSaved: (val) => signInForm.lastName = val,
              onChanged: (val) {
                signInForm.lastName = val;
                checkIfValid(context);
              },
              decoration: InputDecoration(
                hintText: "Last Name",
              ),
              validator: (val) {
                return val.isEmpty ? "Field is required" : null;
              },
            ),
            TextFormField(
              onChanged: (val) {
                signInForm.email = val;
                checkIfValid(context);
              },
              onSaved: (val) => signInForm.email = val,
              decoration: InputDecoration(
                hintText: "Email Address",
              ),
              validator: (val) {
                return val.isEmpty ? "Field is required" : null;
              },
            ),
            TextFormField(
              onChanged: (val) {
                signInForm.password = val;
                checkIfValid(context);
              },
              onSaved: (val) => signInForm.password = val,
              decoration: InputDecoration(
                hintText: "Password",
              ),
              obscureText: true,
              validator: (val) {
                return val.length < 6
                    ? "Password must have at least 6 characters"
                    : null;
              },
            ),
            TextFormField(
              onChanged: (val) {
                signInForm.favouriteNumber = int.parse(val);
                checkIfValid(context);
              },
              onSaved: (val) =>
                 signInForm.favouriteNumber = val.isEmpty ? 0 : int.parse(val),
              decoration: InputDecoration(
                hintText: "Favourite Number (5-10)",
              ),
              validator: (val) {
                if (val.isEmpty) {
                  return "Field is required";
                }
                int value = val.isEmpty ? 0 : int.parse(val);
                if (value < 5 || value > 10) {
                  return "Number can be between 5 to 10";
                }

                return null;
              },
            ),
            const SizedBox(height: 24),
            _loginRegisterButton(context, formKey),
            _replaceModeButton(context),
          ],
        ),
      ),
    );
  }

  Form _loginForm(BuildContext context) {
    final signInForm = Provider.of<SignInForm>(context, listen: true);

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                onChanged: (val) {
                  signInForm.email = val;
                  checkIfValid(context);
                },
                onSaved: (val) => signInForm.email = val,
                decoration: InputDecoration(
                  hintText: "Email Address",
                ),
                validator: (val) {
                  return val.isEmpty ? "Field is required" : null;
                },
              ),
              TextFormField(
                onSaved: (val) => signInForm.password = val,
                onChanged: (val) {
                  signInForm. password = val;
                  checkIfValid(context);
                },
                decoration: InputDecoration(
                  hintText: "Password",
                ),
                obscureText: true,
                validator: (val) {
                  if (val.isEmpty) return "Field is required";

                  return val.length < 6
                      ? "Password must have at least 6 characters"
                      : null;
                },
              ),
              const SizedBox(height: 24),
              _loginRegisterButton(context, formKey),
              _replaceModeButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginRegisterButton (
      BuildContext context, GlobalKey<FormState> formKey) {
    final signInForm = Provider.of<SignInForm>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    void registerOrSignIn() async {
      final form = formKey.currentState;
      form.save();

      // abort login/register if form is invalid
      if (!form.validate()) {
        print("bad");
      }


      switch (signInForm.mode) {
        case RegisterMode.login:
          authService.loginUser(
            email: signInForm.email,
            password: signInForm.password,
          );
          break;

        case RegisterMode.register:
          // create user
          await authService.createUser(
            email: signInForm.email,
            password: signInForm.password,
            firstName: signInForm.firstName,
            lastName: signInForm.lastName,
          );

          // login him first
          await authService.loginUser(
            email: signInForm.email,
            password: signInForm.password,
          );

          // then, initialize his info
          await UserRepositoryImpl().createUserInfo(
              UserInfoModel(
                firstName: signInForm.firstName,
                lastName: signInForm.lastName,
                favouriteNumber: signInForm.favouriteNumber,
              )
          );
          break;
      }
    }

    return Container(
      width: 240,
      child: ElevatedButton(
        child: Text(signInForm.mode == RegisterMode.login ? "Login" : "Register"),
        onPressed: signInForm.isFormValid ? registerOrSignIn : null,
      ),
    );
  }

  _replaceModeButton(BuildContext context) {
    final signInForm = Provider.of<SignInForm>(context, listen: true);

    return FlatButton(
      child: Text(
        signInForm.mode == RegisterMode.login ? "Go to Register" : "Go to Login",
      ),
      onPressed: () {
        signInForm.changeMode();
      },
    );
  }

  void checkIfValid(BuildContext context) {
    final signInForm = Provider.of<SignInForm>(context, listen: false);
    signInForm.checkFormValidation();
  }
}
