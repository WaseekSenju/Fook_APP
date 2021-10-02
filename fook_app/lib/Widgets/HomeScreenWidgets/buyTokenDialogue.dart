import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/getAllTokkens.dart';
import 'package:fook_app/Controllers/buyTokken.dart';
import 'package:fook_app/Controllers/const.dart';
import 'package:fook_app/Models/tokken_model.dart';
import 'package:fook_app/Widgets/gradientBorderButton.dart';

import 'package:provider/provider.dart';

class BuyTokenDialogue extends StatefulWidget {
  BuyTokenDialogue(this.tokenData);
  final Datum tokenData;
  @override
  State<BuyTokenDialogue> createState() => _BuyTokenDialogueState();
}

class _BuyTokenDialogueState extends State<BuyTokenDialogue> {
  @override
  Widget build(BuildContext context) {
    var allTokens = Provider.of<AllTokens>(context);
    return AlertDialog(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32.0),
        ),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.65,
        child: Column(
          children: [
            Text(
              'You are buying an NFT image',
              style: TextStyle(
                color: Theme.of(context).textTheme.headline1!.color,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              widget.tokenData.name,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 12,
            ),
            AspectRatio(
              aspectRatio: 1.7,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
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
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price',
                  style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .headline4!
                          .color, // headline4
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                Container(
                  width: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ImageIcon(
                        AssetImage('lib/Assets/Wallet_Icon.png'),
                        color: Color(0xffE02C87),
                        size: 16,
                      ),
                      Expanded(
                        child: Text(
                          '${widget.tokenData.price.value} ETH',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
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
              child: ElevatedButton(
                child: Text(
                  'Buy it',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText2!.color,
                  ),
                ),
                onPressed: () {
                  setState(() async {
                    String result = await BuyTokken.buyTokken(
                      widget.tokenData.collection.id.toString(),
                      widget.tokenData.id,
                    );
                    if (result == '200') {
                      allTokens.addNewBoughtTokenInAcquired(widget.tokenData);
                      Navigator.pop(context);
                      setState(() {
                        widget.tokenData.price = Price(
                          value: ' ',
                          unit: ' ',
                        );
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Token Bought Successfully'),
                          duration: Duration(milliseconds: 1000),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(Const.LOW_BALANCE_MESSAGE),
                          duration: Duration(milliseconds: 1000),
                        ),
                      );
                    }
                  });
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width * 0.8, 50),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
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
            SizedBox(
              height: 16,
            ),
            Text(
              'Buy buying NFT’s you agree to FOOK’s \n terms & conditions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
