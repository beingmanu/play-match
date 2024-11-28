import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
import '../services/video_call_service.dart';
import '../utils/navigator_helper.dart';
import '../utils/snackbar.dart';
import '../widgets/appbar.dart';
import 'chess/chess_game_screen.dart';
import 'random_connect/random_connect_page.dart';
import 'tic_tac_toe/tictak_game_screen.dart';
import 'truth_and_dare/truth_game_screen.dart';
import 'uno/uno_game_screen.dart';

class PreGameScreen extends StatefulWidget {
  final String game;
  const PreGameScreen({super.key, required this.game});

  @override
  State<PreGameScreen> createState() => _PreGameScreenState();
}

class _PreGameScreenState extends State<PreGameScreen> {
  final VideoCallService videoCallService = VideoCallService();

  @override
  void initState() {
    super.initState();
    getTheRoom();
  }

  getTheRoom() async {
    final user =
        Provider.of<UserProvider>(context, listen: false).userInformation;

    if (widget.game == "UNO") {
      showToast("Coming soon");
      navigateBack(context);
      return;
    }
    await videoCallService
        .findRoom(
            user.sId!,
            widget.game == "TAD"
                ? "12345"
                : widget.game == "TTT"
                    ? "123456"
                    : widget.game == "CHESS"
                        ? "10101"
                        : "22222")
        .then(
      (value) async {
        if (value == null) {
          navigateBack(context);
          return;
        }
        //"bbb4b125-2bba-4350-8469-ff2224bfa7d2"
        await videoCallService.getAuthenticate(user, value).then(
          (token) {
            if (token == null) {
              navigateBack(context);
              return;
            }
            if (widget.game == "TTT") {
              navigateTo(context, TTTGameScreen(roomID: value));
            }
            if (widget.game == "TAD") {
              navigateTo(context, TADGameScreen(roomID: value));
            }
            if (widget.game == "UNO") {
              navigateTo(context, UnoGameScreen(roomID: value));
            }
            if (widget.game == "CHESS") {
              navigateTo(context, ChessGameScreen(token: token));
            }
            if (widget.game == "RANDOM") {
              navigateTo(context, RandomConnectPage(token: token));
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppbar(title: ""),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: LottieBuilder.asset("assets/searchcall.json"),
            ),
          ],
        ),
      ),
    );
  }
}
