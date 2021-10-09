import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fook_app/API/services.dart';
import 'package:fook_app/Controllers/Providers/getAllTokkens.dart';
import 'package:fook_app/Controllers/newTokkenController.dart';
import 'package:fook_app/Models/collections.dart';
import 'package:fook_app/Screens/NavigationScreens/NewUI(CreatePost)/newCollectionDialogue.dart';
import 'package:fook_app/Widgets/gradientBorderButton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:fook_app/Models/tokken_model.dart' as token;

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

  List<String> _collectionNames = [];
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  bool _imageTaken = false;
  String? dropDown = ' ';
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  void createToken(AsyncSnapshot<Collections> snapshot) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      String result = await NewTokenAndCollection.newTokken(
          XFile(_image.path),
          _nameController.text,
          _descriptionController.text,
          _priceController.text,
          snapshot.data!.data
              .firstWhere(
                (element) => element.name == dropDown,
              )
              .id
              .toString());

      if (result == '201') {
        var selectedCollection = snapshot.data!.data.firstWhere(
          (element) => element.name == dropDown,
        );
        var newToken = token.Datum(
          id: snapshot.data!.data
              .firstWhere(
                (element) => element.name == dropDown,
              )
              .id
              .toString(),
          file: _image.path,
          name: _nameController.text,
          thumbnail: ' ',
          description: _descriptionController.text,
          collection: token.Collection(
            id: selectedCollection.id,
            name: selectedCollection.name,
            symbol: selectedCollection.symbol,
            image: selectedCollection.image,
            contract: selectedCollection.contract,
          ),
          currentUserData: token.CurrentUserData(isLiked: false, isOwner: true),
          price: token.Price(value: _priceController.text, unit: 'ether'),
        );

        final allTokkens = Provider.of<AllTokens>(context, listen: false);
        allTokkens.addNewCreatedToken(newToken);


        setState(() {
          _loading = false;
        });
        Fluttertoast.showToast(
            backgroundColor: Colors.green,
            msg:
                'Token Created Successfully.Your transaction processing will take some time.');
        await Future.delayed(const Duration(milliseconds: 3500))
            .whenComplete(() {
          Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
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
        child: Form(
          key: _formKey,
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
                                    onPressed: _imgFromCamera,
                                  ),
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
                                            AssetImage(
                                                'lib/Assets/gallery.png'),
                                            color:
                                                Theme.of(context).primaryColor,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 8,
                  ),
                  child: Text(
                    'Collection',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedItemColor,
                    ),
                  ),
                ),
              ),
              FutureBuilder<Collections>(
                future: BackendServices.getCurrentUserCollections(),
                builder: (ctx, AsyncSnapshot<Collections> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data!.data.isNotEmpty) {
                      _collectionNames = [];
                      snapshot.data!.data.forEach((element) {
                        _collectionNames.add(element.name);
                      });

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                  width: 1,
                                ),
                                color: Theme.of(context).dividerColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: DropdownButton<String>(
                                  hint: Text('Select Collection'),
                                  value: dropDown == " " ? null : dropDown,
                                  icon: Icon(Icons.expand_more),
                                  isExpanded: true,
                                  iconSize: 24,
                                  elevation: 16,
                                  underline: Container(
                                    height: 2,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      dropDown = value;
                                    });
                                  },
                                  items: _collectionNames
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      alignment: Alignment.centerLeft,
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 16,
                            ),
                            child: SizedBox(
                              height: 46,
                              width: MediaQuery.of(context).size.width,
                              child: GradientButton(
                                  strokeWidth: 1,
                                  radius: 25,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xffE02989),
                                      Color(0xffF8A620)
                                    ],
                                  ),
                                  child: Text(
                                    'Create Collection',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .color,
                                    ),
                                  ),
                                  onPressed: () {
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (BuildContext context) =>
                                    showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext bc) =>
                                          NewCollectionDialogue(),
                                    );
                                  }),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            child: Divider(),
                          ),
                          _loading
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        child: CircularProgressIndicator(),
                                        width: 25,
                                        height: 25,
                                      ),
                                    ),
                                    Text(
                                      'Uploading Token',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color,
                                      ),
                                    ),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: DecoratedBox(
                                      decoration: dropDown == ' '
                                          ? BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Theme.of(context)
                                                  .dividerColor)
                                          : BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xffE02989),
                                                  Color(0xffF8A620)
                                                ],
                                              ),
                                            ),
                                      child: ElevatedButton(
                                        child: Text(
                                          'Create Token',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .color,
                                          ),
                                        ),
                                        onPressed: dropDown == ' '
                                            ? null
                                            : () => createToken(snapshot),
                                        style: ButtonStyle(
                                          minimumSize:
                                              MaterialStateProperty.all(
                                            Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                50),
                                          ),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                          shadowColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'User collection not found Please add collection first',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                      );
                    }
                  } else {
                    return SizedBox(
                      child: CircularProgressIndicator(),
                      width: 25,
                      height: 25,
                    );
                  }
                },
              ),
              SizedBox(
                height: 16,
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
