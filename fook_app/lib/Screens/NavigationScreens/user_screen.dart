import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/getAllTokkens.dart';
import 'package:fook_app/Controllers/Providers/userData.dart';
import 'package:fook_app/Controllers/const.dart';
import 'package:fook_app/Screens/signIn_screen.dart';
import 'package:fook_app/Widgets/UserScreenWidgets/grid_userScreen.dart';
import 'package:fook_app/Widgets/UserScreenWidgets/wallet.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Zeroth'),
    Tab(text: 'First'),
    Tab(text: 'Second'),
  ];

  @override
  _UserScreenState createState() => _UserScreenState();
}

Future<void> refreshHome(BuildContext context) async {
  await Provider.of<UserData>(context, listen: false).getUserData();
  await Provider.of<UserData>(context, listen: false).getUserWallet();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    
   //Improvment can me made by not using provider here but in grids 
    
    var data = Provider.of<UserData>(context);
    var userInfo = data.userData.data;

    var tokens = Provider.of<AllTokens>(context);

    var uploadedTokens = tokens.uploadedtokens;
    var downloadedTokens = tokens.acquiredTokens;

    var postCount = 0;
    if (uploadedTokens.data.length < downloadedTokens.data.length) {
      postCount = downloadedTokens.data.length;
    } else if (uploadedTokens.data.length > downloadedTokens.data.length) {
      postCount = uploadedTokens.data.length;
    }

    return DefaultTabController(
      length: 3,
      child: RefreshIndicator(
        onRefresh: () => refreshHome(context),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          primary: true,
          child: Column(
            children: [
              Container(
                height: 25,
              ),
              Stack(children: <Widget>[
                Positioned(
                  top: 0,
                  right: 12,
                  child: GestureDetector(
                    child: Icon(
                      Icons.logout,
                      size: 28,
                      color: Colors.grey[700],
                    ),
                    onTap: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you Sure want to Logout?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Const.setTokken(' ');
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignInPage(),
                                  ),
                                );
                              },
                              child: const Text('Confirm'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '436',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .color),
                              ),
                              Text(
                                'NFTs',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: ClipOval(
                                child: userInfo.image == 'noImage'
                                    ? Image.asset('lib/Assets/user.png')
                                    : Image.network(
                                        userInfo.image,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '@${userInfo.username}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .color,
                                ),
                              ),
                            ),
                            Text(
                              '123',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color,
                              ),
                            ),
                            Text('Followers',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor)),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '0',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .color),
                            ),
                            Text(
                              'Following',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Divider(
                  thickness: 1.5,
                ),
              ),
              TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelColor: Colors.grey,
                labelColor: Theme.of(context).primaryColor,

                //indicatorColor: Colors.blue,
                tabs: const <Widget>[
                  Tab(
                    icon: ImageIcon(
                      AssetImage('lib/Assets/arrow_upward.png'),
                      //color: Colors.grey,
                    ),
                  ),
                  Tab(
                    icon: ImageIcon(
                      AssetImage('lib/Assets/arrow_downward.png'),
                      //color: Colors.grey,
                    ),
                  ),
                  Tab(
                    icon: ImageIcon(
                      AssetImage('lib/Assets/Wallet_Icon.png'),
                      //color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Container(
                height: postCount == 0
                    ? MediaQuery.of(context).size.height
                    : ((postCount / 3) * 128) +
                        kBottomNavigationBarHeight +
                        kTextTabBarHeight,
                child: TabBarView(
                  children: <Widget>[
                    PostGrid('Uploaded NFTs', tokens.uploadedtokens),
                    PostGrid('Acquired NFTs', tokens.acquiredTokens),
                    Wallet('My Wallet'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
