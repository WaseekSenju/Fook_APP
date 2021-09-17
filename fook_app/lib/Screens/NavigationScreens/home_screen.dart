import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/collectionController.dart';
import 'package:fook_app/Controllers/Providers/getAllTokkens.dart';

import 'package:provider/provider.dart';
import '/Widgets/HomeScreenWidgets/token.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> refreshHome(BuildContext context) async {
    await Provider.of<AllTokens>(context, listen: false).getAllTokens();
  }

  @override
  Widget build(BuildContext context) {
    var allTokens = Provider.of<AllTokens>(context);
    var userCollections =
        Provider.of<CollectionController>(context).userCollectionsList;

    return RefreshIndicator(
      onRefresh: () => refreshHome(context),
      child: allTokens.loading
          ? Center(child: (CircularProgressIndicator()))
          : ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                thickness: 1,
              ),
              itemBuilder: (context, index) {
                return TokenWidget(
                    allTokens.tokken
                        .data[allTokens.tokken.data.length - (index + 1)],
                    allTokens.tokken.data.length - (index + 1),
                    false,);
              },
              itemCount: allTokens.tokken.data.length,
            ),
    );
  }
}
//  userCollections.data.any((element) =>
//                         element.id ==
//                         allTokens
//                             .tokken
//                             .data[allTokens.tokken.data.length - (index + 1)]
//                             .collection
//                             .id));