import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../main.dart';
import '../../widgets/basic_widget.dart';
import '../chats/chats_screen.dart';
import '../explore/explore_screen.dart';
import '../profile/user_profile.dart';
import 'home_screen.dart';
import 'play_screen.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int currentTab = 1;
  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        } else {
          setState(() {
            currentTab = 1;
          });
        }
      },
      child: Scaffold(
        body: ClipRRect(
          borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(size.width * .1)),
          child: currentTab == 0
              ? const ExploreScreen()
              : currentTab == 1
                  ? const HomeScreen()
                  : currentTab == 2
                      ? const PlayButtonScreen()
                      : currentTab == 3
                          ? const ChatsScreen()
                          : currentTab == 4
                              ? const UserProfile()
                              : const SizedBox(),
        ),
        backgroundColor: Colors.transparent,
        extendBody: true,
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            height: 80,
            width: size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: theme.colorsList01)),
          ).blurred(
            colorOpacity: 0.1,
            blurColor: Colors.transparent,
            overlay: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                iconwidgets(FontAwesomeIcons.earthAsia, 0),
                iconwidgets(FontAwesomeIcons.house, 1),
                iconwidgets(FontAwesomeIcons.play, 2),
                iconwidgets(FontAwesomeIcons.comment, 3),
                iconwidgets(FontAwesomeIcons.solidUser, 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget iconwidgets(IconData icon, int index) => GestureDetector(
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Column(
            children: [
              basicIcon(icon,
                  color: currentTab == index ? theme.colors08 : null,
                  shadowColor: currentTab == index ? theme.colors08 : null),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 5,
                width: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color:
                      currentTab == index ? theme.colors08 : Colors.transparent,
                ),
              )
            ],
          ),
        ),
        onTap: () => setState(() => currentTab = index),
      );
}
