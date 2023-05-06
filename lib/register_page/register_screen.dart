import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sawari/global/global.dart';
import 'package:sawari/register_page/forgot_passwod.dart';
import 'package:sawari/register_page/login_screen.dart';

import '../homepage/home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((auth) async {
        currentUser = auth.user;
        if (currentUser != null) {
          Map userMap = {
            "id": currentUser!.uid,
            "name": nameController.text.trim(),
            "email": emailController.text.trim(),
            "address": addressController.text.trim(),
            "phone": phoneController.text.trim(),
          };
          DatabaseReference reference =
              FirebaseDatabase.instance.ref().child("users");
          reference.child(currentUser!.uid).set(userMap);
        }
        await Fluttertoast.showToast(msg: "Successfully Register");
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
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
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
                  "Register",
                  style: TextStyle(
                      color:
                          darkTheme ? Colors.green.shade700 : Colors.pinkAccent,
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
                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50),
                                ],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(),
                                  hintText: "Name",
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
                                    child: Icon(Icons.person, size: 22),
                                  ),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "name can't be empty";
                                  }
                                  if (text.length < 2) {
                                    return "please enter a valid name";
                                  }
                                  if (text.length > 49) {
                                    return "name can't be more than 50";
                                  }
                                  return null;
                                },
                                onChanged: (text) {
                                  setState(() {
                                    nameController.text = text;
                                  });
                                },
                              ),
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
                              TextFormField(
                                obscureText: !_passwordVisible,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50),
                                ],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  hintText: "ConfirmPassword",
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
                                    padding:
                                        EdgeInsets.only(left: 0.0, right: 0),
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
                                  if (text != passwordController.text) {
                                    return "Password do not match";
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
                                    confirmPasswordController.text = text;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50),
                                ],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  hintText: "Address",
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
                                      Icons.add_location_alt_sharp,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Address can't be empty";
                                  }
                                  if (EmailValidator.validate(text) == true) {
                                    return null;
                                  }
                                  if (text.length < 2) {
                                    return "please enter a valid Address";
                                  }
                                  if (text.length > 49) {
                                    return "Address can't be more than 100";
                                  }
                                  return null;
                                },
                                onChanged: (text) {
                                  setState(() {
                                    addressController.text = text;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              IntlPhoneField(
                                showCountryFlag: false,
                                dropdownIcon: const Icon(
                                  Icons.arrow_drop_down,
                                  size: 0,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  hintText: "Phone",
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
                                ),
                                initialCountryCode: "IN",
                                onChanged: (text) {
                                  setState(() {
                                    phoneController.text = text.completeNumber;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 22,
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
                                    "Register",
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
                                                const ForgotPasswordScreen()));
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
                                    "Have an account?",
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
                                                    const LogInScreen()));
                                      },
                                      child: Text(
                                        "Sign In",
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
