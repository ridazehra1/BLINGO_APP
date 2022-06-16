// import 'package:blingo2/Services/Firebase_dynamic_link.dart';
import 'package:blingo2/Services/Firebase_dynamic_link.dart';
import 'package:blingo2/Services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blingo2/BottomNavigation/Home/following_tab.dart';
import 'package:blingo2/Locale/locale.dart';
import 'package:blingo2/Theme/colors.dart';

List<String> videos1 = [
  'assets/videos/3.mp4',
  'assets/videos/1.mp4',
  'assets/videos/2.mp4',
];

List<String> videos2 = [
  'assets/videos/4.mp4',
  'assets/videos/5.mp4',
  'assets/videos/6.mp4',
];

List<String> imagesInDisc1 = [
  'assets/user/user1.png',
  'assets/user/user2.png',
  'assets/user/user3.png',
];

List<String> imagesInDisc2 = [
  'assets/user/user4.png',
  'assets/user/user3.png',
  'assets/user/user1.png',
];

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeBody(key: key);
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  void initState(){
    super.initState();
    print(FirebaseAuth.instance.currentUser);
    handleDynamicLinks();
  //  FirebaseDynamicLinkService.initDynamicLink();
  }


  void handleDynamicLinks() async {
    ///To bring INTO FOREGROUND FROM DYNAMIC LINK.
    FirebaseDynamicLinks.instance.onLink.listen((data){
      onSuccess: (PendingDynamicLinkData dynamicLinkData) async {
        await _handleDeepLink(dynamicLinkData);
      };},
      // onError: (OnLinkErrorException e) async {
      //   print('DynamicLink Failed: ${e.message}');
      //   return e.message;
      // },
    );

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data!);
  }

  // bool _deeplink = true;
  _handleDeepLink(PendingDynamicLinkData data) async {
  
     final Uri? deeplink = data.link;
    if (deeplink != null) {
      print('Handling Deep Link | deepLink: $deeplink');
  }
}

  
 
  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = [
      Tab(text: AppLocalizations.of(context)!.following),
      Tab(text: AppLocalizations.of(context)!.forYou),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Stack(
        children: <Widget>[
          TabBarView(
            children: <Widget>[
              FollowingTabPage(videos1, imagesInDisc1, false),
              FollowingTabPage(videos2, imagesInDisc2, true),
            ],
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  TabBar(
                    isScrollable: true,
                    labelStyle: Theme.of(context).textTheme.bodyText1,
                    indicator: const BoxDecoration(color: transparentColor),
                    tabs: tabs,
                  ),
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    top: 14,
                    start: 84,
                    child: const CircleAvatar(
                      backgroundColor: mainColor,
                      radius: 3,
                    ),
                  ),
                ],
              ),
              
            ),
          ),
         
        ],
      ),
    );
  }
}
