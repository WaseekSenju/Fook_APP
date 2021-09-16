import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/collectionController.dart';
import 'package:fook_app/Controllers/Providers/getAllTokkens.dart';
import 'package:fook_app/Controllers/Providers/tokkensInCollection.dart';
import 'package:fook_app/Controllers/Providers/userData.dart';
import 'package:provider/provider.dart';
import '../Screens/NavigationScreens/home_screen.dart';
import '../Screens/NavigationScreens/favourite_screen.dart';
import '../Screens/NavigationScreens/search_screen.dart';
import '../Screens/NavigationScreens/newPost_screen.dart';
import '../Screens/NavigationScreens/user_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabScreen';
  @override
  _TabsScreen createState() => _TabsScreen();
}

class _TabsScreen extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _onItemTapped(int index, BuildContext ctx) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  //List of the Widget that will be used by Bottom Navigation bar
  final List<Widget> _pages = [
    HomeScreen(),
    Search(),
    NewPost(),
    Favourites(),
    UserScreen(),
  ];

  @override
  void initState() {
    print('initStateof Tabs!');

    final allTokkens = Provider.of<AllTokens>(context, listen: false);
    
    allTokkens.getAllTokens();
    allTokkens.getDownloadedtokens();
    allTokkens.getUploadedtokens();
    allTokkens.getLikedTokens();

    final userData = Provider.of<UserData>(context, listen: false);
    userData.getUserData();
    userData.getUserWallet();

    final collectionController =
        Provider.of<CollectionController>(context, listen: false);
    collectionController.getAllCollections().whenComplete(() {
      final List<Map<String, String>> collectionIds = []; // have to change it
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
    });
    final userCollections =
        Provider.of<CollectionController>(context, listen: false);

    userCollections.getUserCollections();
    
    print('testing Collections');
    userCollections.collectionNames.forEach((element) => print(element));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _pages.elementAt(_selectedPageIndex),
        bottomNavigationBar: BottomNavigationBar(
          //elevation: 50,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).accentColor,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
              icon: new Icon(Icons.home_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('lib/Assets/add.png'),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: '',
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedPageIndex,
          onTap: (index) {
            if (index == 2) {
              Navigator.of(context).pushNamed(NewPost
                  .routeName); //Logic for Pushin Camera Screen instead of Navigation

            } else {
              _onItemTapped(index, context);
            }
          },
        ),
      ),
    );
  }
}
