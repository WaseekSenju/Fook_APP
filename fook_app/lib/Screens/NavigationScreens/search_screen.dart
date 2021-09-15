import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/collectionController.dart';
import 'package:fook_app/Controllers/Providers/tokkensInCollection.dart';
import 'package:provider/provider.dart';
import '../../Widgets/SearchScreenWidgets/HorizontalSearchList.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

Future<void> refreshSearch(BuildContext context) async {
  final collectionController =
      Provider.of<CollectionController>(context, listen: false);
  collectionController.getAllCollections().whenComplete(() {
    final List<Map<String, String>> collectionIds = []; // have to change it
    for (int i = 0; i < collectionController.collectionsList.data.length; i++) {
      collectionIds.add({
        collectionController.collectionsList.data[i].id.toString():
            collectionController.collectionsList.data[i].name
      });
    }

    final userTokkens =
        Provider.of<UserTokensController>(context, listen: false);
    userTokkens.getUserTokkens(collectionIds);
  });
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    var userTokens = Provider.of<UserTokensController>(context);
    return RefreshIndicator(
      onRefresh: () => refreshSearch(context),
      child: userTokens.loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              appBar: AppBar(
                toolbarHeight: 100,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                automaticallyImplyLeading: false,
                title: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          top: 25, bottom: 12, left: 16, right: 16),
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
                                color: Colors.transparent,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 5),
                            filled: true,
                            fillColor: Color(0xffF4F4F4),
                            //Icon
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Icon(
                                Icons.search_sharp,
                                size: 25,
                              ),
                            ),
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //Divider
                    Divider(
                      thickness: 2,
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
                        left: 16,
                      ),
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: userTokens.tokkensList.length,
                        itemBuilder: (ctx, index) => SearchList(
                            userTokens.tokkensList[index].keys.first,
                            userTokens.tokkensList[index].values.first),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// Column(
//         children: <Widget>[
//           //Top Search Bar
//           Container(
//             padding: EdgeInsets.only(top: 14, bottom: 12, left: 16, right: 16),
//             child: Container(
//               height: 36,
//               width: 375,
//               child: TextField(
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(25),
//                     borderSide: new BorderSide(
//                       color: Colors.red,
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(25),
//                     borderSide: new BorderSide(
//                       color: Colors.transparent,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(25),
//                     borderSide: new BorderSide(
//                       color: Colors.transparent,
//                     ),
//                   ),
//                   contentPadding: EdgeInsets.only(top: 5),
//                   filled: true,
//                   fillColor: Color(0xffF4F4F4),
//                   //Icon
//                   prefixIcon: Padding(
//                     padding: const EdgeInsets.only(right: 15),
//                     child: Icon(
//                       Icons.search_sharp,
//                       size: 25,
//                     ),
//                   ),
//                   hintText: 'Search',
//                   hintStyle: TextStyle(
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           //Divider
//           Divider(
//             thickness: 1,
//           ),
//           Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.only(
//                   top: 20,
//                   left: 16,
//                 ),
//                 height: MediaQuery.of(context).size.height - 215,
//                 child: ListView(shrinkWrap: true, children: <Widget>[
//                   Container(
//                       height: MediaQuery.of(context).size.height - 215,
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: userTokens.tokkenList.length,
//                         itemBuilder: (ctx, index) => 
//                         SearchList(
//                             userTokens.tokkenList[(userTokens.tokkenList.length-1)-index].keys.first,
//                             userTokens.tokkenList[(userTokens.tokkenList.length-1)-index].values.first),
//                       )
//                       //collectionController.collectionsList.data[index].id.toString(),
//                       ),
//                 ]),
//               ),
//             ],
//           ),
//         ],
//       ),




// FutureBuilder(
//                         future: BackendServices.getCollections(),
//                         builder:
//                             (context, AsyncSnapshot<Collections> snapshot) {
//                           var collection = snapshot.data;
//                           if (snapshot.hasData) {
//                             return ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: collection!.data.length,
//                               itemBuilder: (ctx, index) => SearchList(
//                                 collection.data[index].id.toString(),
//                                 collection.data[index].name,
//                               ),
//                             );
//                           }

//                           return Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }),