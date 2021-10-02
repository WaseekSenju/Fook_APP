import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/DarkTheme.dart';
import 'package:fook_app/Controllers/Providers/getAllTokkens.dart';
import 'package:fook_app/Controllers/Providers/userData.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
//import '/API/services.dart';
//import '/Models/tokken_model.dart';
import '../../Widgets/HomeScreenWidgets/token.dart';

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
    final darkTheme = Provider.of<DarkThemeProvider>(context);
    final data = Provider.of<UserData>(context);
    final wallet = data.userBalance.data;
    String value = ' ';

    if (wallet.value.length > 4) {
      value = wallet.value.substring(0, 4);
    } else {
      value = wallet.value;
    }
    print('homeScreen');
    return RefreshIndicator(
      
      onRefresh: () => refreshHome(context),
      child: allTokens.loading
          ? Center(
              child: (CircularProgressIndicator()),
            )
          : Scaffold(
              backgroundColor: darkTheme.darkTheme
                  ? Color(0xff262B3B)
                  : Color(0xffF2F2F2), //Use provider here
              appBar: AppBar(
                //toolbarHeight: MediaQuery.of(context).size.height * 0.1,
                shadowColor: Colors.transparent,
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                title: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1, color: Theme.of(context).dividerColor),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        //bottom: 20,
                        top: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'NFT Feed',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color:
                                  Theme.of(context).textTheme.headline1!.color,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: ElevatedButton(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ImageIcon(
                                    AssetImage('lib/Assets/Wallet_Icon.png'),
                                    color: Color(0xffE02C87),
                                    size: 16,
                                  ),
                                  Text(
                                    '$value  ETH',
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .color,
                                      fontWeight: FontWeight.w600,
                                      fontFamily:
                                          GoogleFonts.inter().fontFamily,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {},
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).dividerColor,
                                ),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              body: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: TokenWidget(
                        allTokens.tokken
                            .data[allTokens.tokken.data.length - (index + 1)],
                        allTokens.tokken.data.length - (index + 1),
                        false,
                        () => {}),
                  );
                },
                itemCount: allTokens.tokken.data.length,
              ),
            ),
    );
  }
}
