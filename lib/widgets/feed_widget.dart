import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../main.dart';
import '../models/communitie_post.dart';
import '../screens/profile/account_setting.dart';
import 'basic_container.dart';
import 'basic_widget.dart';

class FeedWidget extends StatefulWidget {
  final CommunitiePost postData;
  const FeedWidget({
    super.key,
    required this.postData,
  });

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  bool isOptionshow = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BasicOutLineContainer(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 5),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      border: Border.all(color: theme.colors05, width: 2),
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"))),
                ),
                basicSpace(width: 5),
                myText("@beingmanu",
                    style: theme.headLine01!
                        .copyWith(color: theme.colorCompanion02),
                    padding: 0),
                const Spacer(),
                GestureDetector(
                    onTap: () => setState(() => isOptionshow = !isOptionshow),
                    child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: basicIcon(isOptionshow
                            ? FontAwesomeIcons.x
                            : FontAwesomeIcons.ellipsisVertical))),
              ],
            ),
          ),
          const BasicOutLineContainer(
            padding: EdgeInsets.zero,
            marginv: 0,
          ),
          AnimatedContainer(
            height: isOptionshow ? 0 : size.width * .54,
            width: size.width - 10,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutExpo,
            child: Image.network(
              widget.postData.imageUrl ??
                  "https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
              fit: BoxFit.cover,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            height: !isOptionshow ? 0 : size.width * .54,
            width: size.width - 10,
            curve: Curves.easeInOutExpo,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  tileNpagewidget("Save to your favorite"),
                  tileNpagewidget("Report"),
                ],
              ),
            ),
          ),
          const BasicOutLineContainer(
            padding: EdgeInsets.zero,
            marginv: 0,
          ),
          Row(
            children: [
              Column(
                children: [
                  myText(
                      "${widget.postData.likes!.length} Likes, ${widget.postData.comments!.length} Comments ",
                      style: theme.subtitle01),
                ],
              ),
              const Spacer(),
              basicIcon(FontAwesomeIcons.heart),
              basicIcon(FontAwesomeIcons.comment),
              basicIcon(FontAwesomeIcons.locationArrow)
            ],
          )
        ],
      ),
    );
  }
}
