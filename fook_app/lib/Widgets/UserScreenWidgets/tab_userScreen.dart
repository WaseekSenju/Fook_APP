import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/getAllTokkens.dart';
import 'package:provider/provider.dart';
import 'grid_userScreen.dart';
import 'wallet.dart';

class UserTabs extends StatefulWidget {
  @override
  _UserTabsState createState() => _UserTabsState();
}

class _UserTabsState extends State<UserTabs> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var tokens = Provider.of<AllTokens>(context);
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          indicatorColor: Theme.of(context).primaryColor,
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelColor: Colors.grey,
          labelColor: Theme.of(context).primaryColor,

          //indicatorColor: Colors.blue,
          controller: _tabController,
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
      ),
      body: ListView(
        children: [
          TabBarView(
            controller: _tabController,
            children: <Widget>[
              PostGrid('Uploaded NFTs',tokens.uploadedtokens),
              PostGrid('Acquired NFTs',tokens.acquiredTokens),
              Wallet('My Wallet'),
            ],
          ),
        ],
      ),
    );
  }
}

