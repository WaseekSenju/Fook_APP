import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fook_app/API/services.dart';
import 'package:fook_app/Controllers/Providers/DarkTheme.dart';
import 'package:fook_app/Controllers/Providers/getAllTokkens.dart';
import 'package:fook_app/Controllers/const.dart';
import 'package:fook_app/Controllers/likeToken.dart';
import 'package:fook_app/Models/Transaction.dart' as transactionModel;
import 'package:fook_app/Widgets/HomeScreenWidgets/buyTokenDialogue.dart';
import 'package:fook_app/Widgets/gradientBorderButton.dart';
import 'package:provider/provider.dart';
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

    await SellTokenController.setTokenPriceAndAllow(
      tokenData.id,
      tokenData.collection.id.toString(),
      {"value": price, "unit": "ether"},
    );
    setState(() {
      _loading = false;
    });
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    var allTokens = Provider.of<AllTokens>(context);
    print('print widget Data');
    print(widget.tokenData.collection.id);
    print(widget.tokenData.id);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 62,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text(
                widget.tokenData.name,
                style: TextStyle(
                  fontSize: 14,
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
            Hero(
              tag: widget.tokenData.file,
              child: AspectRatio(
                aspectRatio: 1.7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: widget.tokenData.file.contains('http')
                        ? CachedNetworkImage(
                            imageUrl: widget.tokenData.file,
                            fit: BoxFit.fitWidth,
                          )
                        : Image.file(
                            File(widget.tokenData.file),
                            fit: BoxFit.cover,
                          ),
                  ),
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
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            if (widget.tokenData.price.value != ' ' ||
                widget.tokenData.currentUserData.isOwner)
              !widget.tokenData.currentUserData.isOwner
                  ? Container(
                      height: 1,
                      width: 1,
                    )
                  : Container(
                      height: 150,
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
                                      'All Time Average Price',
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
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setSheetState) {
                                      return InkWell(
                                        onTap: (){
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: Container(
                                          height: 600,
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
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
                                                      controller:
                                                          _priceController,
                                                      keyboardType: TextInputType
                                                          .numberWithOptions(
                                                              decimal: true),
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
                                                            'Enter equal or high price',
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
                                                          if (_priceController
                                                                  .text
                                                                  .isNotEmpty &&
                                                              this.isNumeric(
                                                                  _priceController
                                                                      .text)) {
                                                            if (double.parse(
                                                                    _priceController
                                                                        .text) >=
                                                                double.parse(
                                                                    widget
                                                                        .tokenData
                                                                        .price
                                                                        .value)) {
                                                              setSheetState(() {
                                                                _loading = true;
                                                              });
                                                              FocusScope.of(context).unfocus();
                                                              String result =
                                                                  await SellTokenController
                                                                      .setTokenPriceAndAllow(
                                                                widget
                                                                    .tokenData.id,
                                                                widget.tokenData
                                                                    .collection.id
                                                                    .toString(),
                                                                {
                                                                  "value":
                                                                      _priceController
                                                                          .text,
                                                                  "unit": "ether"
                                                                },
                                                              );
                                                              if (result ==
                                                                  '200') {
                                                                setState(() {
                                                                  widget
                                                                          .tokenData
                                                                          .price
                                                                          .unit =
                                                                      'ether';
                                                                  widget
                                                                          .tokenData
                                                                          .price
                                                                          .value =
                                                                      _priceController
                                                                          .text;
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                                setSheetState(() {
                                                                  _loading =
                                                                      false;
                                                                });
                                                                Fluttertoast
                                                                    .showToast(
                                                                  timeInSecForIosWeb:
                                                                      2,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                  msg:
                                                                      'Price changed successfully',
                                                                );
                                                              } else {
                                                                setSheetState(() {
                                                                  _loading =
                                                                      false;
                                                                });
                                                                Fluttertoast
                                                                    .showToast(
                                                                  backgroundColor:
                                                                      Colors.red,
                                                                  msg: result,
                                                                );
                                                              }
                                                            } else {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Future.delayed(
                                                                  const Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  () {
                                                                Fluttertoast
                                                                    .showToast(
                                                                  timeInSecForIosWeb:
                                                                      2,
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
                                        ),
                                      );
                                    });
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16, top: 16),
                              child: Row(
                                children: [
                                  Text(
                                    'Tap here to set Price',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .color,
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
                    Expanded(
                      child: Text(
                        widget.tokenData.description,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color,
                          //fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
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
                              color: Theme.of(context).primaryColor,
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
                            child: GradientButton(
                              onPressed: () {},
                              strokeWidth: 1,
                              radius: 20,
                              gradient: LinearGradient(
                                colors: [Color(0xffE02989), Color(0xffF8A620)],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                          ),
                          Container(
                            height: 80,
                            width: 150,
                            child: GradientButton(
                              onPressed: () {},
                              strokeWidth: 1,
                              radius: 20,
                              gradient: LinearGradient(
                                colors: [Color(0xffE02989), Color(0xffF8A620)],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: FutureBuilder<transactionModel.Transaction>(
                future: BackendServices.getTokenTransaction(widget.tokenData.id,
                    widget.tokenData.collection.id.toString()),
                builder: (BuildContext context,
                    AsyncSnapshot<transactionModel.Transaction> snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data!.data.length);
                    return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 16,
                            child: GradientButton(
                              strokeWidth: 1,
                              radius: 24,
                              gradient: LinearGradient(
                                colors: [Color(0xffE02989), Color(0xffF8A620)],
                              ),
                              onPressed: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[
                                      Row(children: [
                                        Text( 'Transaction Type',style: TextStyle(
                                            color: themeChange.darkTheme ? Colors.white : Colors.black
                                        ),),
                                        SizedBox(width: 12,),
                                        Text( snapshot.data!.data[index].transactionType, style: TextStyle(
                                          color: themeChange.darkTheme ? Colors.white : Colors.black
                                        ),)
                                      ],
                                      ),
                                      SizedBox(height: 8,),
                                      Row(children: [
                                        Text( 'Username',style: TextStyle(
                                            color: themeChange.darkTheme ? Colors.white : Colors.black
                                        ),),
                                        SizedBox(width: 12,),
                                        Text( snapshot.data!.data[index].fromUser.username != '' ? snapshot.data!.data[index].fromUser.username : snapshot.data!.data[index].toUser.username,
                                          style: TextStyle(
                                              color: themeChange.darkTheme ? Colors.white : Colors.black
                                          ),)
                                      ],
                                      ),
                                      SizedBox(height: 8,),
                                        Container(
                                          width: MediaQuery.of(context).size.width - 40,
                                          child: Text( snapshot.data!.data[index].fromWallet != '' ? snapshot.data!.data[index].fromWallet : snapshot.data!.data[index].fromWallet,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: themeChange.darkTheme ? Colors.white : Colors.black
                                            ),),
                                        )
                                      
                                    ]
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            InkWell(child: Consumer<AllTokens>(
              builder: (context, allTokens, _) {
                return ImageIcon(
                  AssetImage('lib/Assets/redHear.png'),
                  size: 18,
                  color: widget.tokenData.currentUserData.isLiked
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.secondary,
                );
              },
            ), onTap: () {
              //setState(
              //() {
              var token = widget.tokenData;
              if (token.currentUserData.isLiked) {
                LikeTokken.unlikeTokken(
                  widget.tokenData.id,
                  widget.tokenData.collection.id.toString(),
                );

                widget.tokenData.currentUserData.isLiked =
                    !widget.tokenData.currentUserData.isLiked;

                allTokens.removeLike(widget.tokenData.id);
              } else {
                LikeTokken.likeTokken(widget.tokenData.id,
                    widget.tokenData.collection.id.toString());

                widget.tokenData.currentUserData.isLiked =
                    !widget.tokenData.currentUserData.isLiked;

                allTokens.addLike(widget.tokenData.id);
              }
              // },
              //);
            }),
            Padding(
              padding: const EdgeInsets.all(2),
              child: Text(
                '187k',
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.secondary),
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
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.secondary),
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
                    child: widget.tokenData.currentUserData.isOwner
                        ? Container(
                            height: 1,
                            width: 1,
                          )
                        : GradientButton(
                            strokeWidth: 1,
                            radius: 24,
                            gradient: LinearGradient(
                              colors: [Color(0xffE02989), Color(0xffF8A620)],
                            ),
                            child: widget.tokenData.price.unit == ' '
                                ? Text(
                                    'SOLD',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .color,
                                    ),
                                  )
                                : Text(
                                    'Fook it',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .color,
                                    ),
                                  ),
                            onPressed: () async {
                              widget.tokenData.price.unit == ' '
                                  ? ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        content: Text(Const.ALREADY_SOLD),
                                        duration: Duration(milliseconds: 1000),
                                      ),
                                    )
                                  : showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          BuyTokenDialogue(widget.tokenData),
                                    );
                            },
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
