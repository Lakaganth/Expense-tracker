import 'package:fleming_expense_tracker/constants/constants.dart';
import 'package:fleming_expense_tracker/controllers/auth_controller.dart';
import 'package:fleming_expense_tracker/screens/2.authenitication/login_screen.dart';
import 'package:fleming_expense_tracker/utilities/fade_animation.dart';
import 'package:fleming_expense_tracker/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController authController = AuthController.to;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: kRegisterScreenBG,
            width: Get.width,
            height: Get.height,
            child: Stack(
              children: [
                buildHeroWidget(),
                buildInputFields(context),
              ],
            ),
          ),
        ),
      ),
    );
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
                    child: _buildNameTextField(context),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[100]))),
                    padding: EdgeInsets.all(8.0),
                    child: _buildEmailTextField(context),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: _buildPasswordTextField(context),
                  ),
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
              onPressed: () {
                authController.registerWithEmailAndPassword();
              },
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
              onPressed: () => Get.to(LoginScreen()),
              child: Text(
                "Already Registered? Login",
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

  void _passwordEditingComplete(BuildContext context) {
    FocusScope.of(context).unfocus();
    print("Logged in");
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

  void _nameEditingComplete(BuildContext context) {
    FocusScope.of(context).requestFocus(_nameFocusNode);
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

  TextField _buildNameTextField(BuildContext context) {
    return TextField(
      controller: authController.nameController,
      focusNode: _nameFocusNode,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Name",
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
      ),
      autocorrect: false,
      onEditingComplete: () => _nameEditingComplete(context),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
    );
  }

  Positioned buildHeroWidget() {
    return Positioned(
      top: 0,
      width: 350,
      height: 300,
      child: FadeAnimation(
        delay: 1,
        finishingBegin: -20.0,
        finishingEnd: 0.0,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/register_hero.png'),
            ),
          ),
        ),
      ),
    );
  }
}
