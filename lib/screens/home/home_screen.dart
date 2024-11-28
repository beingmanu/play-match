import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../models/user_model.dart';
import '../../provider/user_provider.dart';
import '../../games/game_loader_screen.dart';
import '../../services/api_service.dart';
import '../../services/video_call_service.dart';
import '../../utils/navigator_helper.dart';
import '../../widgets/basic_container.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserDetails user;
  bool isLoading = false;
  ApiService apiService = ApiService();
  VideoCallService videoCallService = VideoCallService();
  late Future<List> _futureHomeData;
  @override
  void didChangeDependencies() {
    user = Provider.of<UserProvider>(context).userInformation;
    _futureHomeData = apiService.getHomeData(user.sId!);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    [
      Permission.bluetoothConnect,
      Permission.microphone,
      Permission.camera,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BasicScafold(
      title: "Hello,  ${user.userName}",
      bgImage: "assets/4.png",
      body: FutureBuilder(
          future: _futureHomeData,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(
                child: circleLoader(),
              );
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  myText("Recent Plays"),
                  gameWidget(
                      size,
                      () =>
                          navigateTo(context, const PreGameScreen(game: "TAD")),
                      "assets/dare.png"),
                  gameWidget(
                      size,
                      () =>
                          navigateTo(context, const PreGameScreen(game: "TTT")),
                      "assets/tictac.png"),
                  gameWidget(size, () {
                    navigateTo(context, const PreGameScreen(game: "UNO"));
                  }, "assets/uno.jpg"),
                  gameWidget(size, () async {
                    navigateTo(context, const PreGameScreen(game: "CHESS"));
                  }, "assets/chess.jpg"),
                  myText("Popular profiles"),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => BasicOutLineContainer(
                            height: size.width * .6,
                            width: size.width * .45,
                            marginh: 8,
                            padding: EdgeInsets.zero,
                            image:
                                "https://images.pexels.com/photos/1376042/pexels-photo-1376042.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15)),
                                        color: theme.colors06),
                                    child: basicIcon(FontAwesomeIcons.heart),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        theme.colorCompanion01
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: myText("@monadarling",
                                      style: theme.headLine01, padding: 0),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  myText("popular Live"),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.generate(
                            6, (index) => popularProfileWidget(size))
                      ],
                    ),
                  ),
                  basicSpace(height: 100)
                ],
              ),
            );
          }),
    );
  }
}

Widget gameWidget(Size size, VoidCallback onTap, String image) =>
    GestureDetector(
      onTap: onTap,
      child: BasicOutLineContainer(
        height: size.width * .5,
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                height: size.width * .5,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                        image: AssetImage(image))),
              ),
              Container(
                height: size.width * .5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.transparent,
                    const Color(0x8A0D0A1C),
                    const Color.fromARGB(209, 13, 10, 28),
                    const Color.fromARGB(255, 13, 10, 28),
                    theme.colorCompanion,
                    theme.colorCompanion,
                  ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          myText("Play Games &",
                              style: theme.title01, padding: 0),
                          myText("Make Friends",
                              style: theme.title02, padding: 0),
                          myText("Win rate 13%",
                              padding: 0,
                              align: TextAlign.right,
                              style: theme.subtitle01)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

Widget popularProfileWidget(Size size) => BasicOutLineContainer(
      height: size.width * .5,
      width: size.width * .4 - 20,
      marginh: 10,
      padding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Image.network(
                "https://images.pexels.com/photos/13191392/pexels-photo-13191392.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=10",
                fit: BoxFit.cover,
                height: size.width * .5 - 37,
                width: double.maxFinite,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                    ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: child,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myText("13.8K views", padding: 5, style: theme.subtitle01),
                  basicIcon(FontAwesomeIcons.circlePlay, color: theme.colors04)
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                        colors: [Colors.transparent, theme.colorCompanion01],
                        end: Alignment.topCenter,
                        begin: Alignment.bottomCenter)),
                child: myText("@babydoll", style: theme.headLine01, padding: 0),
              ),
            ],
          )
        ],
      ),
    );
