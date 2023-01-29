// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickandgo/Controllers/Auth/LoginController.dart';
import 'package:pickandgo/Models/DB/User.dart';
import 'package:pickandgo/Models/Strings/login_screen.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:pickandgo/Models/Utils/Common.dart';
import 'package:pickandgo/Models/Utils/Images.dart';
import 'package:pickandgo/Models/Utils/Routes.dart';
import 'package:pickandgo/Models/Utils/Utils.dart';
import 'package:pickandgo/Models/Validation/FormValidation.dart';
import 'package:pickandgo/Views/Auth/register.dart';
import 'package:pickandgo/Views/Widgets/custom_button.dart';
import 'package:pickandgo/Views/Widgets/custom_back_button.dart';
import 'package:pickandgo/Views/Widgets/custom_text_form_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController _loginController = LoginController();
  final _keyForm = GlobalKey<FormState>();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    // _username.text = 'staff / business@gmail.com';
    _username.text = 'user@gmail.com';
    _password.text = 'User@123';

    //authProcess();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: color3,
        systemNavigationBarColor: color3,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: color6,
      body: SingleChildScrollView(
        child: SafeArea(
            child: SizedBox(
          height: displaySize.height,
          width: displaySize.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Form(
                key: _keyForm,
                child: Stack(
                  children: [
                    Positioned(
                        child: SizedBox(
                      width: displaySize.width,
                      height: displaySize.height,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color3,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.2),
                                BlendMode.dstATop),
                            image: AssetImage(loginScreenBg),
                          ),
                        ),
                        child: const Text(
                          '',
                        ),
                      ),
                    )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: SizedBox(
                              child: TextButton(
                                onPressed: () =>
                                    Routes(context: context).back(),
                                child: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                              ),
                            )),
                        Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(500),
                            child: Container(
                              width: displaySize.width * 0.4,
                              height: displaySize.width * 0.4,
                              color: color7,
                              child: Center(
                                child: SizedBox(
                                  width: displaySize.width * 0.4,
                                  child: Image.asset(logo),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: color7,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(50.0),
                                  topRight: Radius.circular(50.0))),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20.0,
                              ),
                              const Center(
                                child: Text(
                                  Login_title,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                child: CustomTextFormField(
                                    readOnly: false,
                                    height: 5.0,
                                    controller: _username,
                                    backgroundColor: color7,
                                    iconColor: color3,
                                    isIconAvailable: true,
                                    hint: 'Email Address / Username',
                                    icon: Icons.email_outlined,
                                    textInputType: TextInputType.text,
                                    validation: (value) =>
                                        FormValidation.notEmptyValidation(value,
                                            'Invalid Email Address / Username'),
                                    obscureText: false),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                child: CustomTextFormField(
                                    readOnly: false,
                                    height: 5.0,
                                    controller: _password,
                                    backgroundColor: color7,
                                    iconColor: color3,
                                    isIconAvailable: true,
                                    hint: 'Password',
                                    icon: Icons.lock_outline,
                                    textInputType: TextInputType.text,
                                    validation: (value) =>
                                        FormValidation.passwordValidation(
                                            value),
                                    obscureText: true),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 20.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    Login_forget_password_text,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 45.0, vertical: 5.0),
                                child: CustomButton(
                                    buttonText: Login_button_text,
                                    textColor: color6,
                                    backgroundColor: color3,
                                    isBorder: false,
                                    borderColor: color6,
                                    onclickFunction: () async {
                                      FocusScope.of(context).unfocus();
                                      if (_keyForm.currentState!.validate()) {
                                        await _loginController.commonLogin(
                                            context, {
                                          'email': _username.text,
                                          'password': _password.text
                                        });
                                      }
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 20.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () => Routes(context: context)
                                        .navigate(BusinessRegister()),
                                    child: const Text(
                                      Login_register_text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30.0,
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )),
          ),
        )),
      ),
    );
  }

  Future<void> authProcess() async {
    String _token = await User.getSavedToken() as String;
    if (_token != null) {
      CustomUtils.setLoggedToken(_token);
    }
  }
}
