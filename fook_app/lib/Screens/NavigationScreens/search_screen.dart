import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/DarkTheme.dart';
import 'package:fook_app/Controllers/Providers/collectionController.dart';
import 'package:fook_app/Controllers/Providers/tokkensInCollection.dart';
import 'package:provider/provider.dart';
import '../../Widgets/SearchScreenWidgets/HorizontalSearchList.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var latestFetched = false;
  Future<void> refreshSearch(BuildContext context) async {
    final collectionController =
        Provider.of<CollectionController>(context, listen: false);
    collectionController.getAllCollections().whenComplete(() {
      final List<Map<String, String>> collectionIds = [];
      for (int i = 0;
          i < collectionController.collectionsList.data.length;
          i++) {
        collectionIds.add({
          collectionController.collectionsList.data[i].id.toString():
              collectionController.collectionsList.data[i].name
        });
      }

      final userTokkens =
          Provider.of<UserTokensController>(context, listen: false);
      userTokkens.getUserTokkens(collectionIds);
      setState(() {
        latestFetched = true;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    var userTokens = Provider.of<UserTokensController>(context);
    final darkTheme = Provider.of<DarkThemeProvider>(context);
    //userTokens.loading = !latestFetched;
    return RefreshIndicator(
      onRefresh: () => refreshSearch(context),
      child: userTokens.loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              appBar: AppBar(
                toolbarHeight: 100,
                backgroundColor: darkTheme.darkTheme
                    ? Color(0xff262B3B)
                    : Colors.white, //Use provider here
                shadowColor: Colors.transparent,
                automaticallyImplyLeading: false,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16, left: 16),
                      child: Text(
                        'Explore',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.headline1!.color,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 16, bottom: 12, left: 16, right: 16),
                      child: Container(
                        height: 36,
                        width: 375,
                        child: TextField(
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
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 5),
                            filled: true,
                            fillColor: Theme.of(context).canvasColor,
                            //Icon
                            prefixIcon: Icon(
                              Icons.search_sharp,
                              size: 25,
                            ),
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    //Top Search Bar
                    Padding(
                      padding: EdgeInsets.only(
                          //top: 20,
                          left: 8,
                          right: 8),
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: userTokens.tokkensList.length,
                        itemBuilder: (ctx, index) => userTokens
                                .tokkensList[index].values.first.data.isNotEmpty
                            ? SearchList(
                                userTokens.tokkensList[index].keys.first,
                                userTokens.tokkensList[index].values.first)
                            : Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
