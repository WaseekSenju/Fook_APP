import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fook_app/API/services.dart';

import 'package:fook_app/Controllers/Providers/getAllTokkens.dart';

import 'package:fook_app/Controllers/newTokkenController.dart';
import 'package:fook_app/Models/collections.dart';
import 'package:fook_app/Models/tokken_model.dart' as token;
import 'package:fook_app/Screens/NavigationScreens/NewPostScreens/newCollectionScreen.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TokkenPreviewScreen extends StatefulWidget {
  final XFile image;
  //final CollectionController userCollections;

  const TokkenPreviewScreen({
    Key? key,
    required this.image,
    //required this.userCollections,
  }) : super(key: key);

  @override
  _TokkenPreviewScreenState createState() => _TokkenPreviewScreenState();
}

class _TokkenPreviewScreenState extends State<TokkenPreviewScreen> {
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  List<String> _collectionNames = [];
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String dropDown = ' ';
  bool _loading = false;

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
      body: SingleChildScrollView(
        child: Form(
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
                  'Image Preview',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  height: 150,
                  width: 150,
                  child: ClipOval(
                    child: Image.file(
                      File(widget.image.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  _nameController,
                  'Enter the name of the NFT',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  _descriptionController,
                  'Ente the description of the NFT',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  _priceController,
                  'Ente the price of the NFT',
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
                          DropdownButton<String>(
                            value: dropDown == ' '
                                ? _collectionNames.first
                                : dropDown,
                            iconSize: 24,
                            elevation: 16,
                            underline: Container(
                              height: 2,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropDown = newValue!;
                              });
                            },
                            items: _collectionNames
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
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
                              : ElevatedButton(
                                  child: Text(
                                    dropDown == ' '
                                        ? 'Please Select a Collection'
                                        : 'Create Token',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .color),
                                  ),
                                  onPressed: dropDown == ' '
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              _loading = true;
                                            });
                                            String result =
                                                await NewTokenAndCollection
                                                    .newTokken(
                                                        widget.image,
                                                        _nameController.text,
                                                        _descriptionController
                                                            .text,
                                                        _priceController.text,
                                                        snapshot.data!.data
                                                            .firstWhere(
                                                              (element) =>
                                                                  element
                                                                      .name ==
                                                                  dropDown,
                                                            )
                                                            .id
                                                            .toString());

                                            if (result == '201') {
                                              var selectedCollection = snapshot
                                                  .data!.data
                                                  .firstWhere(
                                                (element) =>
                                                    element.name == dropDown,
                                              );
                                              var newToken = token.Datum(
                                                id: snapshot.data!.data
                                                    .firstWhere(
                                                      (element) =>
                                                          element.name ==
                                                          dropDown,
                                                    )
                                                    .id
                                                    .toString(),
                                                file: widget.image.path,
                                                name: _nameController.text,
                                                thumbnail: ' ',
                                                description:
                                                    _descriptionController.text,
                                                collection: token.Collection(
                                                  id: selectedCollection.id,
                                                  name: selectedCollection.name,
                                                  symbol:
                                                      selectedCollection.symbol,
                                                  image:
                                                      selectedCollection.image,
                                                  contract: selectedCollection
                                                      .contract,
                                                ),
                                                currentUserData:
                                                    token.CurrentUserData(
                                                        isLiked: false),
                                                price: token.Price(
                                                    value:
                                                        _priceController.text,
                                                    unit: 'ether'),
                                              );

                                              final allTokkens =
                                                  Provider.of<AllTokens>(
                                                      context,
                                                      listen: false);
                                              allTokkens
                                                  .addNewCreatedToken(newToken);

                                              setState(() {
                                                _loading = false;
                                              });
                                              Fluttertoast.showToast(
                                                  backgroundColor: Colors.red,
                                                  msg:
                                                      'Token Created Successfully.Your transaction processing will take some time.');
                                              await Future.delayed(
                                                      const Duration(
                                                          milliseconds: 3500))
                                                  .whenComplete(() {
                                                Navigator.of(context).pop();
                                                //  Navigator.of(context)
                                                //      .pushNamed(TabsScreen.routeName);
                                              });
                                            } else {
                                              setState(() {
                                                _loading = false;
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(result),
                                                  duration: Duration(
                                                      milliseconds: 1000),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                ),
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
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
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
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NewCollection(
                        tokenImage: File(widget.image.path),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Add a new Collection',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2!.color),
                ),
              )
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
