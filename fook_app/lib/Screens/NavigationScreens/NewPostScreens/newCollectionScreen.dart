import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fook_app/Controllers/newTokkenController.dart';
import 'package:image_picker/image_picker.dart';

class NewCollection extends StatefulWidget {
  NewCollection({Key? key, required this.tokenImage}) : super(key: key);
  final File tokenImage;
  @override
  _NewCollectionState createState() => _NewCollectionState();
}

class _NewCollectionState extends State<NewCollection> {
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
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Display the Picture',
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText2!.color,
        ),
      )),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _imageTaken
                    ? 'Image Preview'
                    : ' Please Select an Image for Collection first',
                style: TextStyle(
                  fontSize: _imageTaken ? 20 : 15,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  height: 150,
                  width: 150,
                  child: ClipOval(
                    child: _imageTaken
                        ? Image.file(
                            File(_image.path),
                            fit: BoxFit.cover,
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.camera,
                              size: 50,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: _imgFromGallery,
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                _nameController,
                'Enter the name of the collection',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                _symbolController,
                'Ente the symbol of collection',
              ),
            ),
            _loading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    height: 25,
                  ),
            ElevatedButton(
              onPressed: _imageTaken
                  ? () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _loading = true;
                        });

                        String result = '201';
                        await NewTokenAndCollection.createNewCollection(_image,
                            _nameController.text, _symbolController.text);

                        if (result == '201') {
                          Fluttertoast.showToast(
                              msg:
                                  'Collection Created Successfully.Your transaction processing will take some time.');
                          await Future.delayed(
                                  const Duration(milliseconds: 2500))
                              .whenComplete(() {
                            Navigator.of(context).pop();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => TokkenPreviewScreen(
                            //       image: XFile(widget.tokenImage.path),
                            //     ),
                            //   ),
                            // );
                          });
                        } else {
                          setState(() {
                            _loading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result),
                              duration: Duration(milliseconds: 1000),
                            ),
                          );
                        }
                      }
                    }
                  : null,
              child: Text(
                'Add Collection',
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText2!.color),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TextField extends StatelessWidget {
  TextField(
    this.controller,
    this.hintText,
  );

  final TextEditingController controller;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.left,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: new BorderSide(
            color: Colors.red,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: new BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: new BorderSide(
            color: Colors.transparent,
          ),
        ),
        contentPadding: EdgeInsets.only(top: 5, left: 15),
        filled: true,
        fillColor: Color(0xffF4F4F4),

        //Icon
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
