import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fook_app/Controllers/sellToken.dart';
import 'package:fook_app/Models/tokken_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TokenDetailScreen extends StatefulWidget {
  TokenDetailScreen(this.tokenData);
  final Datum tokenData;
  @override
  _TokenDetailScreenState createState() => _TokenDetailScreenState();
}

class _TokenDetailScreenState extends State<TokenDetailScreen> {
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  void setPrice(Datum tokenData, String price) async {
    setState(() {
      _loading = true;
    });

    String result = await SellTokenController.setTokenPriceAndAllow(
      tokenData.id,
      tokenData.collection.id.toString(),
      {"value": price, "unit": "ether"},
    );
    setState(() {
      _loading = false;
    });
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context, false);
              },
            )
          ],
          title: Text(widget.tokenData.name),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: Hero(
              tag: widget.tokenData.file,
              child: widget.tokenData.file.contains('http')
                  ? CachedNetworkImage(
                      imageUrl: widget.tokenData.file,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(widget.tokenData.file),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Container(
            height: 80,
            child: widget.tokenData.price.value == ' ' 
                ? Center(
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context,
                                      StateSetter setSheetState) {
                                return Container(
                                  height: 600,
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Text('Modal BottomSheet'),
                                        Padding(
                                          padding: EdgeInsets.all(25),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 22,
                                                right: 22,
                                                bottom: 16,
                                                top: 16),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: TextFormField(
                                              controller: _priceController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textAlign: TextAlign.left,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter some value';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                //Icon
                                                hintText:
                                                    'Enter the new Price of the Token',
                                                hintStyle: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        _loading
                                            ? CircularProgressIndicator()
                                            : IconButton(
                                                onPressed: () async {
                                                  setSheetState(() {
                                                    _loading = true;
                                                  });

                                                  String result =
                                                      await SellTokenController
                                                          .setTokenPriceAndAllow(
                                                    widget.tokenData.id,
                                                    widget
                                                        .tokenData.collection.id
                                                        .toString(),
                                                    {
                                                      "value":
                                                          _priceController.text,
                                                      "unit": "ether"
                                                    },
                                                  );
                                                  if (result == '200') {
                                                    setState(() {
                                                      widget.tokenData.price
                                                          .unit = 'ether';
                                                      widget.tokenData.price
                                                              .value =
                                                          _priceController.text;
                                                    });
                                                    Navigator.pop(context);
                                                    setSheetState(() {
                                                      _loading = false;
                                                    });
                                                    Fluttertoast.showToast(
                                                      backgroundColor:
                                                          Colors.red,
                                                      msg:
                                                          'Price set Successfully',
                                                    );
                                                  } else {
                                                    Fluttertoast.showToast(
                                                      backgroundColor:
                                                          Colors.red,
                                                      msg: result,
                                                    );
                                                  }
                                                },
                                                icon: Icon(Icons.done),
                                              ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            });
                      },
                      child: Text(
                        'Press to set Price',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline2!.color,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                : Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          top: 20,
                          bottom: 19,
                          right: 40,
                        ),
                        child: Column(children: [
                          Text(
                            'Current price',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color,
                              //fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${widget.tokenData.price.unit} ${widget.tokenData.price.value}',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          top: 20,
                          bottom: 19,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'All Time Average Prize',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .color,
                                //fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${widget.tokenData.price.unit} ${widget.tokenData.price.value}',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .color,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          Divider(
            color: Theme.of(context).accentColor,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 107,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    height: 16,
                  ),
                  Text(
                    widget.tokenData.description,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color,
                      //fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Created by ',
                      style: TextStyle(
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        color: Theme.of(context).textTheme.headline1!.color,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' ${widget.tokenData.collection.name}',
                          style: TextStyle(
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Theme.of(context).accentColor,
          ),
          Container(
            height: 160,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Properties',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline1!.color,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 80,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).accentColor,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'ACCESORIES',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .color,
                                ),
                              ),
                              Text(
                                'SUNGLASSES',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                              ),
                              Text(
                                '3% have this trait',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).accentColor,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'ACCESORIES',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .color,
                                ),
                              ),
                              Text(
                                'SUNGLASSES',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                              ),
                              Text(
                                '3% have this trait',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .color,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(
              Icons.favorite,
              color: widget.tokenData.currentUserData.isLiked
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(2),
              child: Text(
                '187k',
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).accentColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: Row(
                children: [
                  ImageIcon(
                    AssetImage('lib/Assets/Subtract.png'),
                    color: Theme.of(context).accentColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      '150k',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).accentColor),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10, left: 5),
              child: Row(
                children: [
                  ImageIcon(
                    AssetImage('lib/Assets/share.png'),
                    color: Theme.of(context).accentColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      '129k',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: TextButton(
                      onPressed: () {},
                      child: widget.tokenData.price.unit == ' '
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 22, right: 22),
                              child: Text(
                                'SOLD',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 22, right: 22),
                              child: Text(
                                'Fook it',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(
                                width: 1.5,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
