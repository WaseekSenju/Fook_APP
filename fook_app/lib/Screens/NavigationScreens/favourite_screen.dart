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

    print('favourite');

    return RefreshIndicator(
      onRefresh: () => refreshFavourites(context),
      child: (allTokens.likedTokens.data.isEmpty)
          ? 
                Center(
                  child: Text(
                    'No Favourites',
                    style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline1!.color),
                  ),
                )
              
          : ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                thickness: 1,
              ),
              itemBuilder: (context, index) {
                return TokenWidget(
                    allTokens.likedTokens
                        .data[allTokens.likedTokens.data.length - (index + 1)],
                    allTokens.likedTokens.data.length - (index + 1),
                    true);
              },
              itemCount: allTokens.likedTokens.data.length,
            ),
    );
  }
}


// FutureBuilder(
//         future: BackendServices.getfavouriteToken(),
//         builder: (context, AsyncSnapshot<Tokken> snapshot) {
//           var postData = snapshot.data;

//           if (snapshot.hasData)
//             return ListView.separated(
//               separatorBuilder: (BuildContext context, int index) =>
//                   const Divider(
//                 thickness: 1,
//               ),
//               itemBuilder: (context, index) {
//                 return TokenWidget(postData!.data[index]);
//               },
//               itemCount: postData!.data.length,
//             );

//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),