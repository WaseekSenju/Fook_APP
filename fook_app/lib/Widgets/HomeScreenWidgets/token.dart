import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/DarkTheme.dart';
import 'package:fook_app/Controllers/Providers/getAllTokkens.dart';
import 'package:fook_app/Controllers/const.dart';
import 'package:fook_app/Controllers/likeToken.dart';
import 'package:fook_app/Models/tokken_model.dart';
import 'package:fook_app/Screens/NavigationScreens/tokenDetail_screen.dart';
import 'package:fook_app/Widgets/HomeScreenWidgets/buyTokenDialogue.dart';
import 'package:fook_app/Widgets/gradientBorderButton.dart';
import 'package:provider/provider.dart';

class TokenWidget extends StatefulWidget {
  TokenWidget(
      this.tokenData, this.index, this.favouriteScreen, this.onFavorite);
  final Datum tokenData;
  final int index;
  final bool favouriteScreen;
  final Function onFavorite;

  @override
  _TokenWidgetState createState() => _TokenWidgetState();
}

class _TokenWidgetState extends State<TokenWidget> {
  // late bool liked;
  // @override
  // void initState() {
  //   super.initState();
  //   liked = widget.tokenData.currentUserData.isLiked;
  // }

  @override
  Widget build(BuildContext context) {
    print('Token');
    var allTokens = Provider.of<AllTokens>(context);
    final darkTheme = Provider.of<DarkThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: darkTheme.darkTheme ? Color(0xff2A3141) : Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 0.1,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      //padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            padding: const EdgeInsets.only(left: 15, right: 15),
            //Top Bar
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.tokenData.collection.image),
                  radius: 16,
                ),
                Container(
                  width: 150,
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    widget.tokenData.collection.name,
                    style: TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500,
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
                  AspectRatio(
                    aspectRatio: 1.6,
                    child: Container(
                      //width: MediaQuery.of(context).size.width,
                      //height: MediaQuery.of(context).size.height / 2,
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
                                  TokenDetailScreen(widget.tokenData, false),
                            ),
                          );
                        },
                      ),
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
              //left: 24,
              // right: 24,
              top: 5,
              bottom: 5,
            ),
            //Likes Shares and Comments
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  child: Row(
                    children: [
                      ImageIcon(
                        AssetImage('lib/Assets/redHear.png'),
                        size: 18,
                        color: widget.tokenData.currentUserData.isLiked
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.secondary,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: Text(
                          '187k',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: widget.favouriteScreen
                      ? () {
                          this.widget.onFavorite(widget.tokenData);
                        }
                      : () async {
                          //setState(
                          // () {
                          if (widget.tokenData.currentUserData.isLiked) {
                            LikeTokken.unlikeTokken(
                              widget.tokenData.id,
                              widget.tokenData.collection.id.toString(),
                            );
                            //widget.tokenData.currentUserData.isLiked =
                            // !widget.tokenData.currentUserData.isLiked;

                            // allTokens.tokken.data[widget.index]
                            //         .currentUserData.isLiked =
                            //     !allTokens.tokken.data[widget.index]
                            //         .currentUserData.isLiked;

                            // allTokens.likedTokens.data.removeWhere(
                            //   (tokken) =>
                            //       tokken.id ==
                            //       allTokens.tokken.data[widget.index].id,
                            // );

                            allTokens.removeLike(widget.tokenData.id);
                          } else {
                            LikeTokken.likeTokken(
                              widget.tokenData.id,
                              widget.tokenData.collection.id.toString(),
                            );
                            //widget.tokenData.currentUserData.isLiked =
                            //!widget.tokenData.currentUserData.isLiked;

                            allTokens.addLike(widget.tokenData.id);

                            // allTokens.tokken.data[widget.index]
                            //         .currentUserData.isLiked =
                            //     !allTokens.tokken.data[widget.index]
                            //         .currentUserData.isLiked;

                            // allTokens.likedTokens.data
                            //     .add(allTokens.tokken.data[widget.index]);
                          }
                        },
                  // );
                  // },
                ),
                Container(
                  height: 24,
                  child: VerticalDivider(
                    thickness: 1,
                  ),
                ),
                Row(
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
                Container(
                  height: 24,
                  child: VerticalDivider(
                    thickness: 1,
                  ),
                ),
                Row(
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
              ],
            ),
          ),
          //Post title and Description
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 20),
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
            padding: const EdgeInsets.only(left: 20, top: 8),
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
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Divider(
              thickness: 0,
            ),
          ),
          //Price and button
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 12,
              bottom: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ImageIcon(
                        AssetImage('lib/Assets/Wallet_Icon.png'),
                        color: Color(0xffE02C87),
                        size: 16,
                      ),
                      Container(
                        width: 70,
                        child: Text(
                          '${widget.tokenData.price.value} ETH',
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                widget.tokenData.currentUserData.isOwner
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
