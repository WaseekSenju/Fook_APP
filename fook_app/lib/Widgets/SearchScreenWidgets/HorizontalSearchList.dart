import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/DarkTheme.dart';
import 'package:provider/provider.dart';
import '/Models/tokken_model.dart';

class SearchList extends StatefulWidget {
  SearchList(this.name, this.tokkenList);
  final String name;
  final Tokken tokkenList;

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Card(
        elevation: 0,
        color: theme.darkTheme ? Color(0xff2A3141) : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 16,
            left: 16,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 6, right: 12, top: 12, bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              widget.tokkenList.data.first.collection.image),
                          radius: 16,
                        ),
                        Container(
                          width: 8,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            '#${widget.name}',
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline1!.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    widget.tokkenList.data.isNotEmpty
                        ? Icon(
                            Icons.navigate_next,
                            size: 25,
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                              right: 25,
                            ),
                            child: Text(
                              'This Collections is Empty',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              if (widget.tokkenList.data.isNotEmpty)
                SizedBox.fromSize(
                  size: const Size.fromHeight(128),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.tokkenList.data.length,
                    itemBuilder: (ctx, index) => Padding(
                      padding: const EdgeInsets.only(right: 2, left: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          height: 128,
                          width: 128,
                          child: widget.tokkenList.data[index].file
                                  .contains('http')
                              ? CachedNetworkImage(
                                  imageUrl: widget.tokkenList.data[index].file,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(widget.tokkenList.data[index].file),
                                  fit: BoxFit.cover,
                                ),
                          // decoration: BoxDecoration(
                          //   image: DecorationImage(
                          //     image: CachedNetworkImageProvider(
                          //       widget.tokkenList.data[index].file,
                          //     ),
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
