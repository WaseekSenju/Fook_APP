import 'package:flutter/material.dart';

import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:fook_app/Controllers/Providers/collectionController.dart';
import 'package:fook_app/Controllers/newTokkenController.dart';
import 'package:fook_app/Widgets/gradientBorderButton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewCollectionDialogue extends StatefulWidget {
  @override
  _NewCollectionDialogueState createState() => _NewCollectionDialogueState();
}

class _NewCollectionDialogueState extends State<NewCollectionDialogue> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _symbolController = TextEditingController();
  bool _imageTaken = false;
  late File _image;
  bool _loading = false;

  ImagePicker picker = ImagePicker();
  _imgFromGallery() async {
    final image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
      _imageTaken = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: StatefulBuilder(
        builder: (
          BuildContext context,
          StateSetter bottomSheetSetState,
        ) =>
            SizedBox(
          height: MediaQuery.of(context).size.height / 1.3,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                'Add a New Collection',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              _imageTaken
                  ? Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: Image.file(
                          _image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: _imgFromGallery,
                          icon: ImageIcon(
                            AssetImage(
                              'lib/Assets/arrow_upward.png',
                            ),
                            color: Theme.of(context).primaryColor,
                            //color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Upload Collection Image',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                        ),
                      ],
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  _nameController,
                  'Collection Name',
                  TextInputType.name,
                  Theme.of(context).cardColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  _symbolController,
                  '#',
                  TextInputType.name,
                  Theme.of(context).cardColor,
                ),
              ),
              SizedBox(
                height: 26,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [Color(0xffE02989), Color(0xffF8A620)],
                  ),
                ),
                child: _loading
                    ? SizedBox(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        child: Text(
                          'Add Collection',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2!.color,
                          ),
                        ),
                        onPressed: _imageTaken
                            ? () async {
                                if (_formKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    _loading = true;
                                  });

                                  //String result = '201';
                                  String result = await NewTokenAndCollection
                                      .createNewCollection(
                                          _image,
                                          _nameController.text,
                                          _symbolController.text);

                                  if (result == '201') {
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    Fluttertoast.showToast(
                                        backgroundColor: Colors.green,
                                        msg:
                                            'Collection Created Successfully.Your transaction processing will take some time.');
                                    await Future.delayed(
                                            const Duration(milliseconds: 2500))
                                        .whenComplete(
                                      () {
                                        // final userCollections =
                                        //     Provider.of<CollectionController>(
                                        //         context,
                                        //         listen: false);
                                        // userCollections
                                        //     .getUserCollections()
                                        //     .whenComplete(
                                        //   () {
                                        //     // userCollections.collectionsList.data
                                        //     //     .forEach((element) {
                                        //     //   print(element.name);
                                        //     // });
                                            Navigator.of(context).pop();
                                          //},
                                        //);
                                      },
                                    );
                                  } else {
                                    setState(() {
                                      _loading = false;
                                    });
                                    Fluttertoast.showToast(
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: Colors.red,
                                      msg: result,
                                    );
                                  }
                                }
                              }
                            : () {},
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.8, 50),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
              SizedBox(
                height: 16,
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: GradientButton(
                  strokeWidth: 1,
                  radius: 25,
                  gradient: LinearGradient(
                    colors: [Color(0xffE02989), Color(0xffF8A620)],
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.headline1!.color,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextField extends StatelessWidget {
  TextField(
    this.controller,
    this.hintText,
    this.inputType,
    this.fieldColor, {
    this.linesOfField = 1,
    this.fieldPadding = const EdgeInsets.only(top: 5, left: 15),
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final Color fieldColor;
  final int linesOfField;
  final EdgeInsets fieldPadding;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: linesOfField,
      keyboardType: inputType,
      controller: controller,
      textAlign: TextAlign.left,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: new BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: new BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
        contentPadding: fieldPadding,
        filled: true,
        fillColor: fieldColor,

        //Icon
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).unselectedWidgetColor,
          fontSize: 14,
        ),
      ),
    );
  }
}
