import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sawari/register_page/register_screen.dart';

import '../global/global.dart';
import '../homepage/home_screen.dart';
import 'forgot_passwod.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);
  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((auth) async {
        currentUser = auth.user;
        await Fluttertoast.showToast(msg: "Successfully Logged In");
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }).catchError((onError) {
        Fluttertoast.showToast(msg: "onError message $onError");
      });
    } else {
      Fluttertoast.showToast(msg: "not all field are valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 33,
                ),
                Image.asset("assets/image/register.png"),
                const SizedBox(
                  height: 22,
                ),
                Text(
                  "LogIn",
                  style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 18,
                              ),
                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50),
                                ],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  hintText: "Email",
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(44),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(left: 0, right: 0),
                                    child: Icon(
                                      Icons.email,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Email can't be empty";
                                  }
                                  if (EmailValidator.validate(text) == true) {
                                    return null;
                                  }
                                  if (text.length < 2) {
                                    return "please enter a valid Email";
                                  }
                                  if (text.length > 49) {
                                    return "Email can't be more than 100";
                                  }
                                  return null;
                                },
                                onChanged: (text) {
                                  setState(() {
                                    emailController.text = text;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              TextFormField(
                                obscureText: !_passwordVisible,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50),
                                ],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  hintText: "Password",
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(44),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(left: 0, right: 0),
                                    child: Icon(
                                      Icons.lock,
                                      size: 22,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      )),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Password can't be empty";
                                  }
                                  if (EmailValidator.validate(text) == true) {
                                    return null;
                                  }
                                  if (text.length < 6) {
                                    return "please enter a valid Password";
                                  }
                                  if (text.length > 49) {
                                    return "Password can't be more than 50";
                                  }
                                  return null;
                                },
                                onChanged: (text) {
                                  setState(() {
                                    passwordController.text = text;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(33),
                                      ),
                                      minimumSize:
                                          const Size(double.infinity, 44)),
                                  onPressed: () {
                                    _submit();
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(fontSize: 18),
                                  )),
                              const SizedBox(
                                height: 18,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                ForgotPasswordScreen()));
                                  },
                                  child: Text(
                                    "Forgot password",
                                    style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )),
                              const SizedBox(
                                height: 13,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Doesn't have an account?",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    RegistrationScreen()));
                                      },
                                      child: Text(
                                        "Register",
                                        style: TextStyle(
                                            color: Colors.green.shade700,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              )
                            ],
                          )),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
