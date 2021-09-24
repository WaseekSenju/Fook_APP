import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fook_app/Controllers/Providers/getAllTokkens.dart';
import 'package:fook_app/Controllers/const.dart';
import 'package:fook_app/Controllers/likeToken.dart';
import 'package:provider/provider.dart';
import '/Controllers/buyTokken.dart';
import '/Controllers/sellToken.dart';
import '/Models/tokken_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TokenDetailScreen extends StatefulWidget {
  TokenDetailScreen(this.tokenData, this.isUserToken);
  final Datum tokenData;
  final bool isUserToken;
  @override
  _TokenDetailScreenState createState() => _TokenDetailScreenState();
}

class _TokenDetailScreenState extends State<TokenDetailScreen> {
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s) != null;
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
}
  @override
  Widget build(BuildContext context) {
    var allTokens = Provider.of<AllTokens>(context);

    return Scaffold(
      key: _scaffoldKey,
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
          if (widget.tokenData.price.value == ' ')
            Padding(
              padding: const EdgeInsets.all(25),
              child: Center(
                child: Text(
                  'This Token is already Sold',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
              ),
            ),

          if (widget.tokenData.price.value != ' ' || widget.tokenData.currentUserData.isOwner)
            !widget.tokenData.currentUserData.isOwner
                ? Container(height: 1,width: 1,)
                :
            Container(
                height:  150,
                child: Column(
                  children: [
                    Row(
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
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
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
                                    .headline1!
                                    .color,
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

                    InkWell(
                      onTap: () {
                        Fluttertoast.showToast(
                          backgroundColor:
                          Colors.red,
                          msg:
                          'Please add equal or high price',
                        );

                        return;
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
                                                  TextInputType.numberWithOptions(decimal: true),
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

                                                  if (_priceController.text
                                                      .isNotEmpty &&
                                                      this.isNumeric(
                                                          _priceController
                                                              .text)) {
                                                    if (double.parse(
                                                        _priceController
                                                            .text) >=
                                                        double.parse(
                                                            widget.tokenData
                                                                .price.value)) {
                                                      setSheetState(() {
                                                        _loading = true;
                                                      });

                                                      String result =
                                                      await SellTokenController
                                                          .setTokenPriceAndAllow(
                                                        widget.tokenData.id,
                                                        widget
                                                            .tokenData
                                                            .collection.id
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
                                                              _priceController
                                                                  .text;
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
                                                        setSheetState(() {
                                                          _loading = false;
                                                        });
                                                        Fluttertoast.showToast(
                                                          backgroundColor:
                                                          Colors.red,
                                                          msg: result,
                                                        );
                                                      }
                                                    }else{
                                                      Navigator.of(context).pop();
                                                      Future.delayed(const Duration(milliseconds: 500), () {

                                                      Fluttertoast.showToast(
                                                       backgroundColor:
                                                       Colors.red,
                                                       msg:
                                                       'Please add equal or high price',
                                                     );


                                                      });

                                                    }

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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16,top: 16),
                        child: Row(
                          children: [
                            Text(
                              'Tap here to set Price',
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline1!.color,
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Icon(
                                Icons.change_circle,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          Divider(
            color: Theme.of(context).colorScheme.secondary,
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
            color: Theme.of(context).colorScheme.secondary,
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
                              color: Theme.of(context).colorScheme.secondary,
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
                              color: Theme.of(context).colorScheme.secondary,
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
            InkWell(
              onTap: (){
                  setState(
                        () {
                          var token = widget.tokenData;
                      if (token.currentUserData.isLiked) {
                        LikeTokken.unlikeTokken(
                            widget.tokenData.id,
                            widget.tokenData.collection.id
                                .toString());
                        widget.tokenData.currentUserData.isLiked = !widget.tokenData.currentUserData.isLiked;
                        allTokens.likedTokens.data.removeWhere(
                                (tokken) =>
                            tokken.id ==
                                token.id);
                      } else {
                        LikeTokken.likeTokken(
                            widget.tokenData.id,
                            widget.tokenData.collection.id
                                .toString());
                        widget.tokenData.currentUserData.isLiked = !widget.tokenData.currentUserData.isLiked;

                        // allTokens.tokken.data[widget.index]
                        //     .currentUserData.isLiked =
                        // !allTokens.tokken.data[widget.index]
                        //     .currentUserData.isLiked;

                        allTokens.likedTokens.data.add(token);
                      }
                    },
                  );
              },
              child: Icon(
                Icons.favorite,
                color: widget.tokenData.currentUserData.isLiked
                    ? Theme.of(context).primaryColor
                    : widget.tokenData.currentUserData.isLiked ? Colors.red : Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2),
              child: Text(
                '187k',
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: Row(
                children: [
                  ImageIcon(
                    AssetImage('lib/Assets/Subtract.png'),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      '150k',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).colorScheme.secondary),
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
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      '129k',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child:  widget.tokenData.currentUserData.isOwner
                        ? Container(height: 1,width: 1,)
                        : TextButton(
                      onPressed: () {
                        widget.tokenData.price.unit == ' '
                            ?
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(Const.ALREADY_SOLD),
                            duration:
                            Duration(milliseconds: 1000),
                          ),
                        )
                            :
                        setState(() async {
                          String result = await BuyTokken.buyTokken(
                            widget.tokenData.collection.id.toString(),
                            widget.tokenData.id,
                          );
                          if (result == '200') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Token Bought Successfully'),
                                duration: Duration(milliseconds: 1000),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(Const.LOW_BALANCE_MESSAGE),
                                duration: Duration(milliseconds: 1000),
                              ),
                            );
                          }
                        });
                      },
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
