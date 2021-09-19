import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fook_app/Models/tokken_model.dart';
import 'package:fook_app/Screens/NavigationScreens/tokenDetail_screen.dart';


class PostGrid extends StatefulWidget {
  PostGrid(this.tabsText, this.postData);
  final String tabsText;
  final Tokken postData;

  @override
  _PostGridState createState() => _PostGridState();
}

class _PostGridState extends State<PostGrid> {
  @override
  Widget build(BuildContext context) {
    print('UserGrid');
    // bool areAcquired;
    // final postData;
    // widget.tabsText == 'Uploaded NFTs'
    //     ? postData = tokens.uploadedtokens
    //     : postData = tokens.acquiredTokens;
    // widget.tabsText == 'Uploaded NFTs'
    //     ? areAcquired = true
    //     : areAcquired = true;

    return SingleChildScrollView(
      primary: false,
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 12),
            child: Text(widget.tabsText,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline1!.color)),
          ),
          if (widget.postData.data.isNotEmpty)
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              primary: false,
              children: List.generate(
                widget.postData.data.length,
                (index) {
                  return GestureDetector(
                    child: Hero(
                      tag: widget.postData.data[index].file,
                      child: Container(
                        height: 128,
                        width: 128,
                        child: widget.postData.data[index].file.contains('http')
                            ? CachedNetworkImage(
                                imageUrl: widget.postData.data[index].file,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(
                                  widget.postData.data[index].file,
                                ),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TokenDetailScreen(widget.postData.data[index],true),
                        ),
                      );
                    },
                  );
                },
              ),
              crossAxisCount: 3,
            ),
          if (widget.postData.data.isEmpty)
            Column(
              children: [
                Container(
                  height: 150,
                ),
                Text(
                  'No Tokens Yet',
                  style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline1!.color),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
