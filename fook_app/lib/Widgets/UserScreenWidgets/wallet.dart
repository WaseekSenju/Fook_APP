import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/userData.dart';

import 'package:provider/provider.dart';

class Wallet extends StatelessWidget {
  Wallet(this.tabsText);
  final String tabsText;
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<UserData>(context);
    final wallet = data.userBalance.data;
    String value = ' ';

    if (wallet.value.length > 4) {
      value = wallet.value.substring(0, 4);
    } else {
      value = wallet.value;
    }
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            tabsText,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).textTheme.headline1!.color),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 32),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage('lib/Assets/eth.png',),
                    size: 45,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    '${wallet.unit} $value',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).textTheme.headline1!.color),
                  ),
                ],
              ),
              Text(
                'Total Money',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: SizedBox(
            height: 40,
            width: 110,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Add Money',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(
                        width: 1.5, color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
