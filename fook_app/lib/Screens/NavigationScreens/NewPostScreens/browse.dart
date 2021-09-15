import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/tokkensInCollection.dart';
import 'package:provider/provider.dart';
import '../../../Widgets/SearchScreenWidgets/HorizontalSearchList.dart';

class Browse extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      var userTokens = Provider.of<UserTokensController>(context);
    return Padding(
      padding: const EdgeInsets.only(top:40.0),
      child: Column(
        children: <Widget>[
          //Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Stack(
              children:[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.only(top: 14, bottom: 12, right: 16),
                    child: Container(
                    height: 36,
                    width: MediaQuery.of(context).size.width - 140,
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
                ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top:16.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.close,
                        size: 25,
                        color: Colors.black,),
                      ),
                    ),
                  )
              ]
            ),
          ),

          Divider(
            thickness: 1,
          ),
         Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 16,
                ),
                height: MediaQuery.of(context).size.height - 215,
                child: ListView(shrinkWrap: true, children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height - 215,
                    child:ListView(shrinkWrap: true, children: <Widget>[
                  Container(
                      height: MediaQuery.of(context).size.height - 215,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            userTokens.tokkensList.length,
                        itemBuilder: (ctx, index) => SearchList(
                           userTokens.tokkensList[index].keys.first,
                            userTokens.tokkensList[index].values.first),
                      )
                      //collectionController.collectionsList.data[index].id.toString(),
                      ),
                ]),
                  )
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
