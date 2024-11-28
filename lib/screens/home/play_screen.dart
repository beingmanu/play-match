import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../games/game_loader_screen.dart';
import '../../main.dart';
import '../../utils/navigator_helper.dart';
import '../../widgets/basic_container.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';
import '../../widgets/matchmaking_widget.dart';

class PlayButtonScreen extends StatefulWidget {
  const PlayButtonScreen({super.key});

  @override
  State<PlayButtonScreen> createState() => _PlayButtonScreenState();
}

class _PlayButtonScreenState extends State<PlayButtonScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BasicScafold(
      bgImage: "assets/5.png",
      title: "Connect",
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                ...List.generate(
                  4,
                  (index) => BasicOutLineContainer(
                    height: size.width * .2,
                    width: size.width * .5 - 20,
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        Image.network(
                          "https://images.pexels.com/photos/2690323/pexels-photo-2690323.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                          fit: BoxFit.cover,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) =>
                                  ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: child,
                          ),
                        ),
                        Flexible(child: myText("Tik tac toe"))
                      ],
                    ),
                  ),
                )
              ],
            ),
            BasicOutLineContainer(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  myText("Find your next vibe tribe"),
                  myText(
                      "Feeling lonely? choose your way to chat or voice call with a cool stranger. It's like instant friend-making, minus the swipe fatigue.",
                      style: theme.subtitle01,
                      align: TextAlign.start,
                      padding: 15),
                  basicSpace(height: 15),
                  GestureDetector(
                    onTap: () => navigateTo(
                        context, const PreGameScreen(game: "RANDOM")),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      width: size.width * .3,
                      decoration: BoxDecoration(
                        color: theme.colors02,
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
                          basicIcon(FontAwesomeIcons.phone),
                          myText("Find", showshadow: false)
                        ],
                      ),
                    ),
                  ),
                  basicSpace(width: 10),
                  basicSpace(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      myText("Learn more", style: theme.subtitle01, padding: 5)
                    ],
                  )
                ],
              ),
            ),
            const MatchmakingWidget(),
            basicSpace(height: 100)
          ],
        ),
      ),
    );
  }
}
