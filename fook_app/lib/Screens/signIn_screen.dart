import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fook_app/Screens/interest_screen.dart';
import 'package:fook_app/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../Controllers/loginController.dart';
import '../Screens/tabs_screen.dart';


class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late File _image;

  ImagePicker picker = ImagePicker();
  _imgFromCamera() async {
    final image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
      _imageTaken = !_imageTaken;
    });
  }

  _imgFromGallery() async {
    final image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
      _imageTaken = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _visibility = false;
  bool _loading = false;
  bool _imageTaken = false;
  bool _firstimeLogin = false;

  void _toggleVisibilty() {
    setState(() {
      _visibility = !_visibility;
    });
  }

  void _signUp(String email, String password, String name) async {
    _firstimeLogin = true;

    setState(() {
      _loading = true;
    });

    String result = _imageTaken
        ? await LoginController.signUpUser(_image, email, password, name)
        : await LoginController.signUpUserWithoutImage(email, password, name);
    setState(() {
      _loading = false;
    });
    if (result == '201') {
      _logIn(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(result),
          duration: Duration(milliseconds: 3000),
        ),
      );
    }
  }

  void _logIn(String email, String password) async {
    setState(() {
      _loading = true;
    });
    Map<String, String> result =
        await LoginController.loginUser(email, password);

    if (result['status'] == '200') {
      setState(() {
        _loading = false;
      });
      _firstimeLogin
          ? Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => InterestsPage(),
              ),
            )
          : Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => TabsScreen(),
              ),
            );
      _firstimeLogin = false;
      //});
    } else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Loging In Failed'),
          duration: Duration(milliseconds: 1000),
        ),
      );
    }
  }

  pageState _status = pageState.LoginPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: _status == pageState.LoginPage ? 50 : 1,
                ),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: _imageTaken
                        ? Image.file(
                            _image,
                            fit: BoxFit.cover,
                          )
                        : Image.asset('lib/Assets/Fook.png'),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Welcome to the NFTs \n Universe',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(22),
                  height: 90,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: Image.asset('lib/Assets/googleLogin.png'),
                        ),
                        Container(
                          width: 56,
                        ),
                        Text(
                          _status == pageState.LoginPage
                              ? 'Log In with Google'
                              : 'Sign In with Google',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: new BorderSide(
                                width: 1, color: Theme.of(context).accentColor),
                          ),
                        )),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: 1.0,
                          width: 32,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      Text(
                        'OR',
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 14),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: 1.0,
                          width: 32,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                //Email Field
                Container(
                  padding:
                      EdgeInsets.only(left: 22, right: 22, bottom: 16, top: 16),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.left,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else if (!value.contains('@')) {
                        return 'please enter a valid Email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: new BorderSide(
                          width: 0.5,
                          color: Colors.red,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: new BorderSide(
                            width: 0.5, color: Theme.of(context).primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: new BorderSide(
                            width: 0.5, color: Theme.of(context).accentColor),
                      ),
                      contentPadding: EdgeInsets.only(top: 5, left: 15),
                      filled: true,
                      fillColor: Color(0xffF4F4F4),

                      //Icon
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                if (_status == pageState.SignupPage)
                  Container(
                    padding: EdgeInsets.only(
                      left: 22,
                      right: 22,
                      bottom: 16,
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: _nameController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: new BorderSide(
                            width: 0.5,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: new BorderSide(
                            width: 0.5,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: new BorderSide(
                            width: 0.5,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(top: 5, left: 15),
                        filled: true,
                        fillColor: Color(0xffF4F4F4),
                        //Icon

                        hintText: 'Name',
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                //Password Field
                Container(
                  padding: EdgeInsets.only(
                    left: 22,
                    right: 22,
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: _passwordController,
                    obscureText: !_visibility,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: new BorderSide(
                          width: 0.5,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: new BorderSide(
                          width: 0.5,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: new BorderSide(
                          width: 0.5,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(top: 5, left: 15),
                      filled: true,
                      fillColor: Color(0xffF4F4F4),
                      //Icon
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: !_visibility
                            ? IconButton(
                                icon: Icon(
                                  Icons.visibility_rounded,
                                  size: 15,
                                ),
                                onPressed: _toggleVisibilty,
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.visibility_off_rounded,
                                  size: 15,
                                ),
                                onPressed: _toggleVisibilty,
                              ),
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                if (_status == pageState.SignupPage)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Press the Icon to add Your Image!',
                          style: TextStyle(
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext bc) {
                                  return SafeArea(
                                    child: Container(
                                      child: new Wrap(
                                        children: <Widget>[
                                          new ListTile(
                                              leading:
                                                  new Icon(Icons.photo_library),
                                              title: new Text('Photo Library'),
                                              onTap: () {
                                                _imgFromGallery();
                                                Navigator.of(context).pop();
                                              }),
                                          new ListTile(
                                            leading:
                                                new Icon(Icons.photo_camera),
                                            title: new Text('Camera'),
                                            onTap: () {
                                              _imgFromCamera();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.photo_camera,
                            color: Color(0xffE02989),
                          ),
                        ),
                      ],
                    ),
                  ),
                _loading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(colors: [
                                Color(0xffE02989),
                                Color(0xffF8A620)
                              ])),
                          child: ElevatedButton(
                            child: Text(
                              _status == pageState.LoginPage
                                  ? 'Log In with Email'
                                  : 'Sign Up with Email',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                //_status==pageState.LoginPage?
                                _status == pageState.LoginPage
                                    ? _logIn(
                                        _emailController.text, //hehe
                                        _passwordController.text)
                                    : _signUp(
                                        _emailController.text,
                                        _passwordController.text,
                                        _nameController.text,
                                      );
                              }
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(Size(
                                  MediaQuery.of(context).size.width * 0.8, 50)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                          ),
                        ),
                      ),

                if (_status == pageState.LoginPage)
                  Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                Container(height: MediaQuery.of(context).size.height * 0.1),
                new GestureDetector(
                  onTap: () {
                    setState(() {
                      _image = File('');
                      if (_status == pageState.SignupPage) {
                        _status = pageState.LoginPage;
                        _imageTaken = false;
                      } else {
                        _status = pageState.SignupPage;
                      }
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                      text: _status == pageState.LoginPage
                          ? 'Don\'t have an account?'
                          : 'Already have an account?',
                      style: TextStyle(
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        color: Theme.of(context).textTheme.headline1!.color,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: _status == pageState.LoginPage
                              ? ' Sign Up'
                              : ' Log In',
                          style: TextStyle(
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
