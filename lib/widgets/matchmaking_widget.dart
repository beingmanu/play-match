import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../config/assets.dart';
import '../main.dart';
import 'basic_container.dart';
import 'basic_widget.dart';

class MatchmakingWidget extends StatefulWidget {
  const MatchmakingWidget({super.key});

  @override
  State<MatchmakingWidget> createState() => _MatchmakingWidgetState();
}

class _MatchmakingWidgetState extends State<MatchmakingWidget> {
  int index = 0;
  bool isShow = false;
  bool isliked = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BasicOutLineContainer(
      width: size.width,
      child: Column(
        children: [
          myText("Find your neighbor-boo!"),
          basicSpace(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: size.width * .5,
                width: size.width * .4,
                child: Hero(
                  tag: girlsImageList[index],
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: theme.colors01),
                            color: isShow ? Colors.black12 : Colors.transparent,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                opacity: isShow ? 0.5 : 1,
                                image: NetworkImage(girlsImageList[index]))),
                      ),
                      Center(
                        child: AnimatedOpacity(
                          opacity: isShow ? 1 : 0,
                          duration: const Duration(milliseconds: 100),
                          child: basicIcon(
                            isliked
                                ? FontAwesomeIcons.heart
                                : FontAwesomeIcons.trashCan,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.width * .5,
                width: size.width * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isShow = true;
                          isliked = true;
                        });
                        Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            setState(() {
                              isShow = false;
                              if (index == 3) {
                                index = 0;
                              } else {
                                index++;
                              }
                            });
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: size.width * .3,
                        decoration: BoxDecoration(
                          color: theme.colors04,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: theme.colors03,
                                blurRadius: 10,
                                offset: const Offset(1, 2))
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            myText("Fire", showshadow: false),
                            basicIcon(FontAwesomeIcons.solidHeart,
                                color: Colors.red)
                          ],
                        ),
                      ),
                    ),
                    myText("-Or-", style: theme.headLine01, padding: 0),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isShow = true;
                          isliked = false;
                        });
                        Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            setState(() {
                              isShow = false;
                              if (index == 3) {
                                index = 0;
                              } else {
                                index++;
                              }
                            });
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        width: size.width * .3,
                        decoration: BoxDecoration(
                            color: theme.colors01,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  color: theme.colors03,
                                  blurRadius: 10,
                                  offset: const Offset(1, 2))
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            myText("Meh", showshadow: false),
                            basicIcon(FontAwesomeIcons.heartCrack,
                                color: Colors.red),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
