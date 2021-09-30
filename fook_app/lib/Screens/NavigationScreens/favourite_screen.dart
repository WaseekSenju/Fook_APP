import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/getAllTokkens.dart';

import 'package:provider/provider.dart';
import '../../Widgets/HomeScreenWidgets/token.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

Future<void> refreshFavourites(BuildContext context) async {
  await Provider.of<AllTokens>(context, listen: false).getLikedTokens();
}

class _FavouritesState extends State<Favourites> {

  @override
  Widget build(BuildContext context) {
    var allTokens = Provider.of<AllTokens>(context, listen: false);
   

    return RefreshIndicator(
      onRefresh: () => refreshFavourites(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor, //Use provider here
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          shadowColor: Colors.transparent,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  //bottom: 20,
                  top: 20,
                ),
                child: Text(
                  'My Favorites',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.headline1!.color,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: (allTokens.likedTokens.data.isEmpty)
            ? Center(
                child: Text(
                  'No Favourites',
                  style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline1!.color),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 4),
                child: ListView.builder(
                  // separatorBuilder: (BuildContext context, int index) =>
                  //     const Divider(
                  //   thickness: 1,
                  // ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: TokenWidget(
                          allTokens.likedTokens.data[
                              allTokens.likedTokens.data.length - (index + 1)],
                          allTokens.likedTokens.data.length - (index + 1),
                          true,
                          () => {refreshFavourites(context)}),
                    );
                  },
                  itemCount: allTokens.likedTokens.data.length,
                ),
              ),
      ),
    );
  }
}


