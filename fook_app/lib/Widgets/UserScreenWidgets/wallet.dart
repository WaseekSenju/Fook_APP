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
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12,
              left: 16,
            ),
            child: Text(
              tabsText,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Theme.of(context).textTheme.headline1!.color),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 32),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).textTheme.headline1!.color),
              ),
              Text(
                'Ethereum',
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).textTheme.headline4!.color,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 32,
          ),
          child: Container(
            width:MediaQuery.of(context).size.width/3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: [Color(0xffE02989), Color(0xffF8A620)],
                ),
              ),
              child: ElevatedButton(
                child: Text(
                  'Add Money',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText2!.color,
                  ),
                ),
                onPressed: () {},
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width * 0.8, 50),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
            ),
          ),

          // SizedBox(
          //   height: 40,
          //   width: 110,
          //   child: TextButton(
          //     onPressed: () {},
          //     child: Text(
          //       'Add Money',
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         fontSize: 10,
          //       ),
          //     ),
          //     style: ButtonStyle(
          //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //         RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(18.0),
          //           side: BorderSide(
          //               width: 1.5, color: Theme.of(context).primaryColor),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        )
      ],
    );
  }
}
