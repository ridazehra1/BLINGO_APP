// ignore_for_file: prefer_const_constructors

import 'package:blingo2/Auth/Signin/signin_temp.dart';
import 'package:blingo2/Auth/Signup/signup.dart';
import 'package:blingo2/Components/left_toolbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blingo2/BottomNavigation/Home/comment_sheet.dart';
import 'package:blingo2/Components/custom_button.dart';
import 'package:blingo2/Components/rotated_image.dart';
import 'package:blingo2/Locale/locale.dart';
import 'package:blingo2/Routes/routes.dart';
import 'package:blingo2/Theme/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:localstorage/localstorage.dart';

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class FollowingTabPage extends StatelessWidget {
  final List<String> videos;
  final List<String> images;
  final bool isFollowing;

  final int? variable;

  FollowingTabPage(this.videos, this.images, this.isFollowing, {this.variable});

  @override
  Widget build(BuildContext context) {
    return FollowingTabBody(videos, images, isFollowing, variable);
  }
}

class FollowingTabBody extends StatefulWidget {
  final List<String> videos;
  final List<String> images;

  final bool isFollowing;
  final int? variable;

  FollowingTabBody(this.videos, this.images, this.isFollowing, this.variable);

  @override
  _FollowingTabBodyState createState() => _FollowingTabBodyState();
}

class _FollowingTabBodyState extends State<FollowingTabBody> {
  final LocalStorage storage = new LocalStorage('user');
  var uid;

  PageController? _pageController;
  int current = 0;
  bool isOnPageTurning = false;

  void scrollListener() {
    if (isOnPageTurning &&
        _pageController!.page == _pageController!.page!.roundToDouble()) {
      setState(() {
        current = _pageController!.page!.toInt();
        isOnPageTurning = false;
      });
    } else if (!isOnPageTurning &&
        current.toDouble() != _pageController!.page) {
      if ((current.toDouble() - _pageController!.page!).abs() > 0.1) {
        setState(() {
          isOnPageTurning = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController!.addListener(scrollListener);
    uid = storage.getItem("useruid'");
    print(uid);
  }

  data() {
    if (FirebaseAuth.instance.currentUser != null) {
      print("user " + FirebaseAuth.instance.currentUser.toString());
    } else {
      print("No");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      PageView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemBuilder: (context, position) {
          return VideoPage(
            widget.videos[position],
            widget.images[position],
            pageIndex: position,
            currentPageIndex: current,
            isPaused: isOnPageTurning,
            isFollowing: widget.isFollowing,
          );
        },
        onPageChanged: widget.variable == null
            ? (i) async {
                if (FirebaseAuth.instance.currentUser == null) {
                  await showModalBottomSheet(
                    shape: const OutlineInputBorder(
                        borderSide: BorderSide(color: transparentColor),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16.0))),
                    context: context,
                    isScrollControlled: true,
                    isDismissible: false,
                    builder: (context) {
                      return SizedBox(
                          height: MediaQuery.of(context).size.width * 1.2,
                          child: Signup());
                    },
                  );
                }
              }
            : null,
        itemCount: widget.videos.length,
      ),
      const lefttoolbar_h(
        dCount: '3',
      ),
      FutureBuilder(
          future: data(),
          builder: (ctx, snapshot) {
            return Text("");
          })
    ]);
  }
}

class VideoPage extends StatefulWidget {
  final String video;
  final String image;
  final int? pageIndex;
  final int? currentPageIndex;
  final bool? isPaused;
  final bool? isFollowing;

  VideoPage(this.video, this.image,
      {this.pageIndex, this.currentPageIndex, this.isPaused, this.isFollowing});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with RouteAware {
  late VideoPlayerController _controller;
  bool initialized = false;
  bool isLiked = false;

  final LocalStorage storage = new LocalStorage('user');
  var uid;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.video)
      ..initialize().then((value) {
        setState(() {
          _controller.setLooping(true);
          initialized = true;
        });
      });
  }

  @override
  void didPopNext() {
    print("didPopNext");
    _controller.play();

    super.didPopNext();
  }

  @override
  Future<void> didPushNext() async {
    print("didPushNext");
    _controller.pause();
    uid = await storage.getItem("useruid'");
    print("user");
    super.didPushNext();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(
        this, ModalRoute.of(context) as PageRoute<dynamic>); //Subscribe it here
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pageIndex == widget.currentPageIndex &&
        !widget.isPaused! &&
        initialized) {
      _controller.play();
    } else {
      _controller.pause();
    }
    var locale = AppLocalizations.of(context)!;
//    if (_controller.value.position == _controller.value.duration) {
//      setState(() {
//      });
//    }
    if (widget.pageIndex == 2) _controller.pause();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            },
            child: _controller.value.isInitialized
                ? VideoPlayer(_controller)
                : const SizedBox.shrink(),
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            end: -10.0,
            bottom: 80.0,
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _controller.pause();
                    Navigator.pushNamed(context, PageRoutes.userProfilePage);
                  },
                  child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/user.webp')),
                ),
                CustomButton(
                  Icon(
                    Icons.favorite,
                    color: isLiked ? mainColor : secondaryColor,
                  ),
                  '8.2k',
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                ),
                CustomButton(
                    Icon(
                      Icons.chat_bubble,
                      color: secondaryColor,
                    ),
                    '287', onPressed: () {
                  commentSheet(context);
                }),
                CustomButton(
                  ImageIcon(
                    const AssetImage('assets/icons/ic_views.png'),
                    color: secondaryColor,
                  ),
                  '1.2k',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: RotatedImage(widget.image),
                ),
              ],
            ),
          ),
          widget.isFollowing!
              ? Positioned.directional(
                  textDirection: Directionality.of(context),
                  end: 27.0,
                  bottom: 320.0,
                  child: CircleAvatar(
                      backgroundColor: mainColor,
                      radius: 8,
                      child: Icon(
                        Icons.add,
                        color: secondaryColor,
                        size: 12.0,
                      )),
                )
              : const SizedBox.shrink(),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.only(bottom: 60.0),
                child: LinearProgressIndicator(
                    //minHeight: 1,
                    )),
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            start: 12.0,
            bottom: 72.0,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '@emiliwilliamson\n',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5)),
                TextSpan(text: locale.comment8),
                TextSpan(
                    text: '  ${locale.seeMore}',
                    style: TextStyle(
                        color: secondaryColor.withOpacity(0.5),
                        fontStyle: FontStyle.italic))
              ]),
            ),
          )
        ],
      ),
    );
  }
}
