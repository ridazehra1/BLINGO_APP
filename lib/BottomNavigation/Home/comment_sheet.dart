import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blingo2/Components/entry_field.dart';
import 'package:blingo2/Locale/locale.dart';
import 'package:blingo2/Theme/colors.dart';

class Comment {
  final String? image;
  final String? name;
  final String? comment;
  final String? time;

  Comment({this.image, this.name, this.comment, this.time});
}

void commentSheet(BuildContext context) async {
  var locale = AppLocalizations.of(context)!;

  var userget =[];

  List<Comment> comments = [
    Comment(
      image: 'assets/user/user1.png',
      name: 'Emili Williamson',
      comment: locale.comment1,
      time: ' 5' + locale.minAgo!,
    ),
    Comment(
      image: 'assets/user/user2.png',
      name: 'Yella Jackson',
      comment: locale.comment2,
      time: ' 15' + locale.minAgo!,
    ),
    Comment(
      image: 'assets/user/user3.png',
      name: 'Lisa devil',
      comment: locale.comment3,
      time: ' 1' + locale.dayAgo!,
    ),
    Comment(
      image: 'assets/user/user4.png',
      name: 'Emila Wattson',
      comment: locale.comment4,
      time: ' 2' + locale.dayAgo!,
    ),
    Comment(
      image: 'assets/user/user1.png',
      name: 'Emili Williamson',
      comment: locale.comment1,
      time: ' 5' + locale.minAgo!,
    ),
    Comment(
      image: 'assets/user/user2.png',
      name: 'Yella Jackson',
      comment: locale.comment2,
      time: ' 15' + locale.minAgo!,
    ),
    Comment(
      image: 'assets/user/user3.png',
      name: 'Lisa devil',
      comment: locale.comment3,
      time: ' 1' + locale.dayAgo!,
    ),
    Comment(
      image: 'assets/user/user4.png',
      name: 'Emila Wattson',
      comment: locale.comment4,
      time: ' 2' + locale.dayAgo!,
    ),
  ];


  user() async {
     var data = await  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    //  print(data.data());

     return [data.data()];
     
  }


  sendComment(){
    print(FirebaseAuth.instance.currentUser!.uid);
  }

  await showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          borderSide: BorderSide.none),
      context: context,
      builder: (context) => Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Stack(
              children: <Widget>[
                FadedSlideAnimation(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          locale.comments!,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: lightTextColor),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 60.0),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: <Widget>[
                                  Divider(
                                    color: darkColor,
                                    thickness: 1,
                                  ),
                                  ListTile(
                                    leading: Image.asset(
                                      comments[index].image!,
                                      scale: 2.3,
                                    ),
                                    title: Text(comments[index].name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                height: 2,
                                                color: disabledTextColor)),
                                    subtitle: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: comments[index].comment,
                                        ),
                                        TextSpan(
                                            text: comments[index].time,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption),
                                      ]),
                                    ),
                                    trailing: ImageIcon(
                                      AssetImage('assets/icons/ic_like.png'),
                                      color: disabledTextColor,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      )
                    ],
                  ),
                  beginOffset: Offset(0, 0.3),
                  endOffset: Offset(0, 0),
                  slideCurve: Curves.linearToEaseOut,
                ),
               
                FutureBuilder(
                  future: user(),
                  builder: (context,snapshot){
                     print(snapshot.data );
                  
                    if(snapshot.hasData){
                        // print(snapshot.data );
                    var data = snapshot.data as List ;
                    // print(data[0]["photoUrl"]);
                    return  Align(
                  alignment: Alignment.bottomCenter,
                  child: EntryField(
                    counter: null,
                    padding: EdgeInsets.zero,
                    hint: locale.writeYourComment,
                    fillColor: darkColor,
                    prefix: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: CircleAvatar(
                        backgroundImage:NetworkImage(
                          // FirebaseAuth.instance.currentUser!.photoURL!
                         data[0]["photoUrl"]
                        ),
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: (){
                        print("ok");
                      },
                      child: Icon(
                        Icons.send,
                        color: mainColor,
                        
                      ),
                    ),
                  ));
                    }
                    else{
                      
                    }
                    return Container();
                
                  },
                )
              ],
            ),
          ));
}
