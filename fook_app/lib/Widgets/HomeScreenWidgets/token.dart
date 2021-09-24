import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/getAllTokkens.dart';
import 'package:fook_app/Controllers/buyTokken.dart';
import 'package:fook_app/Controllers/const.dart';
import 'package:fook_app/Controllers/likeToken.dart';
import 'package:fook_app/Models/tokken_model.dart';
import 'package:fook_app/Screens/NavigationScreens/tokenDetail_screen.dart';
import 'package:provider/provider.dart';

class TokenWidget extends StatefulWidget {
  TokenWidget(this.tokenData, this.index, this.favouriteScreen,this.onFavorite);
  final Datum tokenData;
  final int index;
  final bool favouriteScreen;
  final Function onFavorite;

  @override
  _TokenWidgetState createState() => _TokenWidgetState();
}

class _TokenWidgetState extends State<TokenWidget> {
  late bool liked;
  @override
  void initState() {
    super.initState();
    liked = widget.tokenData.currentUserData.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    var allTokens = Provider.of<AllTokens>(context);

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              //Top Bar
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(widget.tokenData.collection.image),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      widget.tokenData.collection.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline1!.color,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    '1 day ago',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                ],
              ),
            ),
            //Image
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
              ),
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      child: GestureDetector(
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TokenDetailScreen(widget.tokenData,false),
                            ),
                          );
                        },
                      ),
                    ),
                    // Positioned(
                    //     top: 99,
                    //     bottom: 99,
                    //     left: 161,
                    //     right: 161,
                    //     child: Image.asset(
                    //       'lib/Assets/play.png',
                    //       scale: 2,
                    //     )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 5,
              ),
              //Likes Shares and Comments
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10, left: 15),
                    child: Row(
                      children: [
                        InkWell(
                          child: Consumer<AllTokens>(
                            builder: (context, allTokkens, child) => Icon(
                              Icons.favorite,
                              color: liked
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                          ),
                          onTap: widget.favouriteScreen
                              ? () {
                            LikeTokken.unlikeTokken(
                                widget.tokenData.id,
                                widget.tokenData.collection.id
                                    .toString());
                            liked = !liked;

                            allTokens.tokken.data[widget.index]
                                .currentUserData.isLiked =
                            !allTokens.tokken.data[widget.index]
                                .currentUserData.isLiked;

                            allTokens.likedTokens.data.removeWhere(
                                    (tokken) =>
                                tokken.id ==
                                    allTokens.tokken
                                        .data[widget.index].id);
                            this.widget.onFavorite();
                          }
                              : () async {
                                  setState(
                                    () {
                                      if (liked) {
                                        LikeTokken.unlikeTokken(
                                            widget.tokenData.id,
                                            widget.tokenData.collection.id
                                                .toString());
                                        liked = !liked;

                                        allTokens.tokken.data[widget.index]
                                                .currentUserData.isLiked =
                                            !allTokens.tokken.data[widget.index]
                                                .currentUserData.isLiked;

                                        allTokens.likedTokens.data.removeWhere(
                                            (tokken) =>
                                                tokken.id ==
                                                allTokens.tokken
                                                    .data[widget.index].id);
                                      } else {
                                        LikeTokken.likeTokken(
                                            widget.tokenData.id,
                                            widget.tokenData.collection.id
                                                .toString());
                                        liked = !liked;

                                        allTokens.tokken.data[widget.index]
                                                .currentUserData.isLiked =
                                            !allTokens.tokken.data[widget.index]
                                                .currentUserData.isLiked;

                                        allTokens.likedTokens.data.add(allTokens
                                            .tokken.data[widget.index]);
                                      }
                                    },
                                  );
                                },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Text(
                            '187k',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage(
                            'lib/Assets/Subtract.png',
                          ),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Post title and Description
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15),
              child: Text(
                widget.tokenData.name,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                widget.tokenData.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.headline1!.color,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 5),
              child: Text(
                "NTF Image",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary, fontSize: 12),
              ),
            ),
            //Price and button
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${widget.tokenData.price.unit} ${widget.tokenData.price.value}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline1!.color,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () async {
                      print(widget.tokenData.price.unit);
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
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          
                          content: Text(
                              'Are you Sure want to Buy \'${widget.tokenData.name}\''),
                          actions: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {

                                    setState(() async {
                                      String result = await BuyTokken.buyTokken(
                                        widget.tokenData.collection.id
                                            .toString(),
                                        widget.tokenData.id,
                                      );
                                      if (result == '200') {
                                        allTokens.addNewBoughtTokenInAcquired(
                                            widget.tokenData);
                                        Navigator.pop(context);
                                        setState(() {
                                          widget.tokenData.price = Price(
                                            value: ' ',
                                            unit: ' ',
                                          );
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Token Bought Successfully'),
                                            duration:
                                                Duration(milliseconds: 1000),
                                          ),
                                        );
                                      } else {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(Const.LOW_BALANCE_MESSAGE),
                                            duration:
                                                Duration(milliseconds: 1000),
                                          ),
                                        );
                                      }
                                    });
                                  },
                                  child: const Text('Proceed'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(
                              width: 1.5,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
