import 'package:flutter/material.dart';
import 'package:fook_app/Screens/tabs_screen.dart';
import '/Widgets/InterestScreen/chip.dart';

class InterestsPage extends StatefulWidget {
  static const routeName = '/interestsScreen';

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  @override
  void initState() {
    super.initState();
    Chips.resetChips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 22, bottom: 16),
                  child: Text(
                    'What are you interested In?',
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline1!.color,
                      fontSize: 24,
                    ),
                  ),
                ),
                Text(
                  'Select some topics you\'re interested in to \n help personalize your Fook experience',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline1!.color,
                    fontSize: 16,
                  ),
                ),
                Container(
                  height: 40,
                ),
                buildChips(context),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Stack(children: [
        Material(
          elevation: 10,
          child: Container(
            height: 60,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                      colors: [Color(0xffE02989), Color(0xffF8A620)])),
              child: ElevatedButton(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                    left: 22,
                    right: 22,
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2!.color,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => TabsScreen(),
                    ),
                  );
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildChips(BuildContext context) => Wrap(
        runSpacing: 10,
        spacing: 10,
        children: Chips.all
            .map((chip) => InkWell(
                  onTap: () {
                    setState(() {
                      chip.isSelected = !chip.isSelected;
                    });
                  },
                  child: Chip(
                    labelPadding: EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: 22,
                      right: 22,
                    ),
                    label: Text(chip.label),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: chip.isSelected
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                    backgroundColor: chip.isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    side: BorderSide(
                      width: 1.5,
                      color: chip.isSelected
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ))
            .toList(),
      );
}
