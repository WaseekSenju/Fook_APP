import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
    return Card(
        elevation: 0.5,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: widget.tokkenList.data.isNotEmpty ? 0 : 8,
                bottom:  widget.tokkenList.data.isNotEmpty ? 0 : 8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '#${widget.name}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline1!.color,
                    ),
                  ),
                  widget.tokkenList.data.isNotEmpty
                      ? Icon(
                          Icons.navigate_next,
                          size: 34,
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
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            if (widget.tokkenList.data.isNotEmpty)
              Container(
                height: 20,
              ),
            if (widget.tokkenList.data.isNotEmpty)
              SizedBox.fromSize(
                size: const Size.fromHeight(128),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.tokkenList.data.length,
                    itemBuilder: (ctx, index) => Padding(
                      padding: const EdgeInsets.only(right: 1),
                      child: Container(
                        height: 128,
                        width: 128,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              widget.tokkenList.data[index].file,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ));
  }
}
