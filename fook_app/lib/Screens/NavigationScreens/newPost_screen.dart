import 'package:flutter/material.dart';
import 'package:fook_app/Controllers/Providers/collectionController.dart';
import 'package:fook_app/Screens/NavigationScreens/NewPostScreens/newTokkenPreview.dart';
import 'package:provider/provider.dart';
import './NewPostScreens/camera.dart';
import 'NewPostScreens/browse.dart';
import 'NewPostScreens/roll.dart';
import 'package:image_picker/image_picker.dart';

class NewPost extends StatefulWidget {
  static const routeName = '/newPost';
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  int _pageIndex = 0;

  Future<void> _getImage() async {
    var galleryImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (galleryImage != null) {
      final List<String> collectionNames = [];
      final userCollections =
          Provider.of<CollectionController>(context, listen: false);
      userCollections.userCollectionsList.data.forEach((element) {
        collectionNames.add(element.name);
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TokkenPreviewScreen(
            collectionNames: collectionNames,
            image: galleryImage,
          ),
        ),
      );
    }
  }

  List<Widget> _newPostScreens = [
    Browse(),
    Camera(),
    //Roll(), //it's commented out
  ];
  void _onItemTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: _newPostScreens[_pageIndex]),
          Align(
            alignment: Alignment.bottomCenter,
            child: Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
              child: BottomNavigationBar(
                elevation: .5,
                currentIndex: _pageIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Text(
                      'BROWSE',
                      style: TextStyle(color: Colors.white),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Text(
                      'CAMERA',
                      style: TextStyle(color: Colors.white),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Text(
                      'ROLL',
                      style: TextStyle(color: Colors.white),
                    ),
                    label: '',
                  ),
                ],
                onTap: (index) {
                  if (index == 0 || index == 1)
                    _onItemTapped(index);
                  else
                    _getImage();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
