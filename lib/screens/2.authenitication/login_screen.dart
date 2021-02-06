import 'package:fleming_expense_tracker/constants/constants.dart';
import 'package:fleming_expense_tracker/controllers/auth_controller.dart';
import 'package:fleming_expense_tracker/screens/2.authenitication/register_screen.dart';
import 'package:fleming_expense_tracker/utilities/fade_animation.dart';
import 'package:fleming_expense_tracker/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = AuthController.to;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: kLoginScreenBG,
          width: Get.width,
          height: Get.height,
          child: Stack(
            children: [
              buildMoonAnimation(),
              buildbigFlightAnimation(),
              buildInputFields(context),
            ],
          ),
        ),
      ),
    ));
  }

  Padding buildInputFields(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: [
          SizedBox(
            height: Get.height / 2.3,
          ),
          FadeAnimation(
            delay: 1.3,
            finishingBegin: 10.0,
            finishingEnd: 0,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: kShadowColor,
                        blurRadius: 10.0,
                        offset: Offset(0, 10))
                  ]),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[100]))),
                    child: _buildEmailTextField(context),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: _buildPasswordTextField(context),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
          FadeAnimation(
            delay: 1.35,
            finishingBegin: 10.0,
            finishingEnd: 0,
            child: CustomRaisedButtton(
              onPressed: authController.signInWithEmailAndPassword,
              buttonText: "Login",
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
          FadeAnimation(
            delay: 1.3,
            finishingBegin: 10.0,
            finishingEnd: 0,
            child: FlatButton(
              onPressed: () => Get.to(RegisterScreen()),
              child: Text(
                "New User? Register",
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Positioned buildbigFlightAnimation() {
    return Positioned(
      top: 240,
      left: 220,
      width: 180,
      height: 200,
      child: FadeAnimation(
        delay: 1.2,
        finishingBegin: 10.0,
        finishingEnd: 0.0,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login_big_flight.png'),
            ),
          ),
        ),
      ),
    );
  }

  Positioned buildMoonAnimation() {
    return Positioned(
      top: -40,
      left: -60,
      width: 180,
      height: 200,
      child: FadeAnimation(
        delay: 1,
        finishingBegin: -20.0,
        finishingEnd: 0.0,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login_moon.png'),
            ),
          ),
        ),
      ),
    );
  }

  void _passwordEditingComplete(BuildContext context) {
    FocusScope.of(context).unfocus();
    authController.signInWithEmailAndPassword();
  }

  TextField _buildPasswordTextField(BuildContext context) {
    return TextField(
      controller: authController.passwordController,
      focusNode: _passwordFocusNode,
      onEditingComplete: () => _passwordEditingComplete(context),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Password",
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
    );
  }

  void _emailEditingComplete(BuildContext context) {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  TextField _buildEmailTextField(BuildContext context) {
    return TextField(
      controller: authController.emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Email or Phone number",
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
      ),
      autocorrect: false,
      onEditingComplete: () => _emailEditingComplete(context),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }
}
