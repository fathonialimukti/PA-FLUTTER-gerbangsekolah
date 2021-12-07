import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gerbangsekolah/Services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureTextPassword = true;

  final _formKey = GlobalKey<FormState>();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  @override
  void initState() {
    _emailController.text = 'teacher1@demo.com';
    _passwordController.text = '123456789';
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Colors.blue, Colors.amber],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 1.0),
              stops: <double>[0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 75.0),
              child: Image(
                  height:
                      MediaQuery.of(context).size.height > 800 ? 191.0 : 150,
                  fit: BoxFit.fill,
                  image: const AssetImage('assets/img/login_logo.png')),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(top: 23.0),
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Card(
                          elevation: 2.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            width: 300.0,
                            height: 190.0,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 20.0,
                                        left: 25.0,
                                        right: 25.0),
                                    child: TextFormField(
                                      focusNode: focusNodeEmail,
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(
                                          fontFamily: 'WorkSansSemiBold',
                                          fontSize: 16.0,
                                          color: Colors.black),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.envelope,
                                          color: Colors.black,
                                          size: 22.0,
                                        ),
                                        hintText: 'Email Address',
                                        hintStyle: TextStyle(
                                            fontFamily: 'WorkSansSemiBold',
                                            fontSize: 17.0),
                                      ),
                                      validator: (value) {
                                        if (!EmailValidator.validate(
                                            value.toString())) {
                                          return 'Please enter valid email';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 250.0,
                                    height: 1.0,
                                    color: Colors.grey[400],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 20.0,
                                        left: 25.0,
                                        right: 25.0),
                                    child: TextFormField(
                                      focusNode: focusNodePassword,
                                      controller: _passwordController,
                                      obscureText: _obscureTextPassword,
                                      style: const TextStyle(
                                          fontFamily: 'WorkSansSemiBold',
                                          fontSize: 16.0,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: const Icon(
                                          FontAwesomeIcons.lock,
                                          size: 22.0,
                                          color: Colors.black,
                                        ),
                                        hintText: 'Password',
                                        hintStyle: const TextStyle(
                                            fontFamily: 'WorkSansSemiBold',
                                            fontSize: 17.0),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _obscureTextPassword = !_obscureTextPassword;
                                            });
                                          },
                                          child: Icon(
                                            _obscureTextPassword
                                                ? FontAwesomeIcons.eye
                                                : FontAwesomeIcons.eyeSlash,
                                            size: 20.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      textInputAction: TextInputAction.go,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 170.0),
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.blue,
                                offset: Offset(1.0, 6.0),
                                blurRadius: 20.0,
                              ),
                              BoxShadow(
                                color: Colors.amber,
                                offset: Offset(1.0, 6.0),
                                blurRadius: 20.0,
                              ),
                            ],
                            gradient: LinearGradient(
                                colors: <Color>[
                                  Colors.blue,
                                  Colors.amber,
                                ],
                                begin: FractionalOffset(0.2, 0.2),
                                end: FractionalOffset(1.0, 1.0),
                                stops: <double>[0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          child: MaterialButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.amber,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 42.0),
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                      fontFamily: 'WorkSansBold'),
                                ),
                              ),
                              onPressed: () async {
                                Map creds = {
                                  'email': _emailController.text,
                                  'password': _passwordController.text,
                                  'device_name': 'mobile',
                                };
                                if (_formKey.currentState!.validate()) {
                                  Provider.of<Auth>(context, listen: false)
                                      .login(creds: creds);
                                }
                              }),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
