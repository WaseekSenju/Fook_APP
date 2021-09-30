import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/DarkTheme.dart';
import 'package:fook_app/Widgets/gradientBorderButton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewPostScreen extends StatefulWidget {
  static const routeName = '/newPost';

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

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

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  bool _imageTaken = false;
  String dropDown = ' ';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 62,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text(
                'Add a new NFT',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.headline1!.color,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).unselectedWidgetColor,
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            )
          ],
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3.5,
                child: _imageTaken
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          _image,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ImageIcon(
                            AssetImage(
                              'lib/Assets/arrow_upward.png',
                            ),
                            color: Theme.of(context).primaryColor,
                            //color: Colors.grey,
                          ),
                          Text(
                            'Upload your NFT image.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).unselectedWidgetColor,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 150,
                                child: GradientButton(
                                    strokeWidth: 1,
                                    radius: 25,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xffE02989),
                                        Color(0xffF8A620)
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        ImageIcon(
                                          AssetImage('lib/Assets/camera.png'),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text('Camera',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline1!
                                                    .color)),
                                      ],
                                    ),
                                    onPressed: _imgFromCamera),
                              ),
                              SizedBox(
                                width: 150,
                                child: GradientButton(
                                    strokeWidth: 1,
                                    radius: 25,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xffE02989),
                                        Color(0xffF8A620)
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        ImageIcon(
                                          AssetImage('lib/Assets/gallery.png'),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          'Gallery',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline1!
                                                  .color),
                                        ),
                                      ],
                                    ),
                                    onPressed: _imgFromGallery),
                              ),
                            ],
                          )
                        ],
                      ),
              ),
            ),
            SizedBox(height: 52),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(_nameController, 'Enter the name of the NFT',
                  TextInputType.name, Theme.of(context).cardColor),
            ),
            SizedBox(height: 52),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                _descriptionController,
                'Ente the description of the NFT',
                TextInputType.multiline,
                Theme.of(context).cardColor,
                linesOfField: 5,
                fieldPadding: const EdgeInsets.only(
                  top: 25,
                  left: 15,
                  right: 15,
                ),
              ),
            ),
            SizedBox(height: 52),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                _priceController,
                'Ente the price of the NFT',
                TextInputType.number,
                Theme.of(context).cardColor,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Collection',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).unselectedWidgetColor,
                ),
              ),
            ),
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
