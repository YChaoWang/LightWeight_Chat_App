import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  File? _selectedImage;
  bool _imagepicked = false;
  var _isAuthenticating = false;
  Future<void> _submit() async {
    bool isValid = _form.currentState!.validate();

    if (!isValid || !_isLogin && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    _form.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userCredential = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        print(userCredential);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': imageUrl,
        });
        _imagepicked = true;
        print(imageUrl);
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // ...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.maxFinite,
        child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/chat.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                height: 430,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                      blurStyle: BlurStyle.normal,
                    ),
                  ],
                ),
                child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Form(
                                key: _form,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!_isLogin)
                                      UserImagePicker(
                                        onPickImage: (pickedImage) {
                                          _selectedImage = pickedImage;
                                        },
                                      ),
                                    TextFormField(
                                      // key: const ValueKey('email'),
                                      keyboardType: TextInputType.emailAddress,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      autocorrect: false,
                                      decoration: const InputDecoration(
                                          labelText: 'Email Address'),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty ||
                                            !value.contains('@')) {
                                          return 'Please enter a valid email address.';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredEmail = value!;
                                      },
                                    ),
                                    if (!_isLogin)
                                      TextFormField(
                                        decoration: InputDecoration(
                                            labelText: 'Username'),
                                        enableSuggestions: false,
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty ||
                                              value.trim().length < 4) {
                                            return 'Please enter at least 4 characters.';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _enteredUsername = value!;
                                        },
                                      ),
                                    TextFormField(
                                      // key: const ValueKey('password'),
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                          labelText: 'Password'),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().length < 6) {
                                          return 'Please enter a valid password with at least 6 characters';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredPassword = value!;
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    if (_isAuthenticating)
                                      CircularProgressIndicator()
                                    else
                                      ElevatedButton(
                                        onPressed: _submit,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                        ),
                                        child:
                                            Text(_isLogin ? 'Login' : 'Signup'),
                                      ),
                                    if (!_isAuthenticating)
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _isLogin = !_isLogin;
                                          });
                                        },
                                        child: Text(_isLogin
                                            ? 'Create new account'
                                            : 'I already have an account.'),
                                      ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
