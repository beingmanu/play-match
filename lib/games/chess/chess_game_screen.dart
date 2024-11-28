import 'package:dyte_core/dyte_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';

import '../../main.dart';
import '../../models/user_model.dart';
import '../../provider/user_provider.dart';
import '../../provider/video_call_provider.dart';
import '../../screens/profile/widgets/profile_image_widget.dart';
import '../../utils/snackbar.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';
import '../../widgets/main_button.dart';
import 'chess_provider.dart';
import 'helper.dart';
import 'peice.dart';

class ChessGameScreen extends StatefulWidget {
  final String token;
  const ChessGameScreen({super.key, required this.token});

  @override
  State<ChessGameScreen> createState() => _ChessGameScreenState();
}

class _ChessGameScreenState extends State<ChessGameScreen> {
  List<List<ChessPiece?>>? board;
  List<List<int>> validMoves = [];
  late UserDetails userDetails;
  bool isJoined = false;
  bool isVideoOn = false;
  bool isAudioOn = false;
  List<DyteJoinedMeetingParticipant> activeUser = [];
  List<DyteTextMessage> dyteMessages = [];

  bool? isYourTurn;
  bool checkStatus = false;
  int selectedRow = -1;
  int selectedCol = -1;
  bool canLeave = false;
  List<ChessPiece> whitePiecesTaken = [];
  List<ChessPiece> blackPiecesTaken = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((value) => gameInIT());
  }

  gameInIT() {
    Provider.of<VideoCallProvider>(context, listen: false).callInIT(
        widget.token,
        Provider.of<UserProvider>(context, listen: false).userInformation);
    Provider.of<ChessGameProvider>(context, listen: false).initBoard();
  }

  assignSymbol() {
    List<String> totalUser = [activeUser[0].userId, userDetails.sId!];
    totalUser.sort();
    if (totalUser.indexWhere((element) => element == userDetails.sId) == 0) {
      Provider.of<ChessGameProvider>(context, listen: false).changeTurn(true);
    } else {
      Provider.of<ChessGameProvider>(context, listen: false).changeTurn(false);
    }
  }

  @override
  void didChangeDependencies() {
    userDetails = Provider.of<UserProvider>(context).userInformation;
    isJoined = Provider.of<VideoCallProvider>(context).isJoined;
    isVideoOn = Provider.of<VideoCallProvider>(context).isVideoOn;
    isAudioOn = Provider.of<VideoCallProvider>(context).isAudioOn;
    activeUser = Provider.of<VideoCallProvider>(context).activeUsers;
    isYourTurn = Provider.of<ChessGameProvider>(context).isLocaluserTurn;
    checkStatus = Provider.of<ChessGameProvider>(context).checkStatus;
    whitePiecesTaken = Provider.of<ChessGameProvider>(context).whitePiecesTaken;
    blackPiecesTaken = Provider.of<ChessGameProvider>(context).blackPiecesTaken;
    board = Provider.of<ChessGameProvider>(context).board;
    validMoves = Provider.of<ChessGameProvider>(context).validMoves;
    dyteMessages = Provider.of<VideoCallProvider>(context).dyteMessages;
    if (dyteMessages.isNotEmpty) {
      if (dyteMessages.last.userId != userDetails.sId ||
          DateTime.parse(dyteMessages.last.time)
                  .difference(DateTime.now())
                  .inSeconds <
              2) {
        List<int> intList =
            dyteMessages.last.message.split(',').map(int.parse).toList();

        Provider.of<ChessGameProvider>(context, listen: false)
            .pieceSelected(intList[0], intList[1], context);
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canLeave,
      child: BasicScafold(
        title: "",
        floatButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(
              heroTag: "Video",
              backgroundColor: theme.colorCompanion02,
              onPressed: () =>
                  Provider.of<VideoCallProvider>(context, listen: false)
                      .toggleVideo(),
              child: basicIcon(isVideoOn
                  ? FontAwesomeIcons.video
                  : FontAwesomeIcons.videoSlash),
            ),
            FloatingActionButton(
              heroTag: "Audio",
              backgroundColor: theme.colorCompanion02,
              onPressed: () =>
                  Provider.of<VideoCallProvider>(context, listen: false)
                      .toggleAudio(),
              child: basicIcon(isAudioOn
                  ? FontAwesomeIcons.microphone
                  : FontAwesomeIcons.microphoneSlash),
            ),
            FloatingActionButton(
              backgroundColor: Colors.red,
              heroTag: "Call",
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              onPressed: () {
                setState(() => canLeave = true);
                Provider.of<VideoCallProvider>(context, listen: false)
                    .leaveCall(context);
              },
              child: basicIcon(FontAwesomeIcons.phone),
            )
          ],
        ),
        body: !isJoined
            ? Center(
                child: myText("wait for Join the call"),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  myText(checkStatus ? "CHECK!" : ""),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.generate(
                          whitePiecesTaken.length,
                          (index) => DeadPiece(
                              imagepath: whitePiecesTaken[index].imagePath),
                        )
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.generate(
                          blackPiecesTaken.length,
                          (index) => DeadPiece(
                              imagepath: blackPiecesTaken[index].imagePath),
                        )
                      ],
                    ),
                  ),
                  isYourTurn != null && board != null
                      ? Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: theme.colorWhite, width: 5)),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: theme.colorBlack, width: 5)),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 8,
                                ),
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 8 * 8,
                                itemBuilder: (BuildContext context, int index) {
                                  int row = index ~/ 8;
                                  int col = index % 8;
                                  bool isValidMove = false;
                                  for (var position in validMoves) {
                                    if (position[0] == row &&
                                        position[1] == col) {
                                      isValidMove = true;
                                    }
                                  }
                                  return ChessBox(
                                      isBlack: isWhite(index),
                                      piece: board![row][col],
                                      isSelected: selectedRow == row &&
                                          selectedCol == col,
                                      isValidMove: isValidMove,
                                      onTap: () {
                                        if (isYourTurn!) {
                                          Provider.of<ChessGameProvider>(
                                                  context,
                                                  listen: false)
                                              .pieceSelected(row, col, context);
                                          Provider.of<VideoCallProvider>(
                                                  context)
                                              .sendMessage("$row,$col");
                                        }
                                      });
                                },
                              ),
                            ),
                          ),
                        )
                      : MainButton(
                          isLoading: false,
                          title: "Start Play",
                          onTap: () {
                            if (activeUser.length > 1) {
                              assignSymbol();
                            } else {
                              showToast("Please Wait for the Other Player");
                            }
                          },
                        ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.all(8),
                            height: 200,
                            decoration: BoxDecoration(
                                border: Border.all(color: theme.colors03),
                                borderRadius: BorderRadius.circular(15)),
                            child: isVideoOn
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: const VideoView(
                                      isSelfParticipant: true,
                                    ),
                                  )
                                : const Center(
                                    child: ProfileImageWidget(),
                                  )),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          height: 200,
                          decoration: BoxDecoration(
                              border: Border.all(color: theme.colors03),
                              borderRadius: BorderRadius.circular(15)),
                          child: activeUser.any(
                                    (element) =>
                                        element.userId != userDetails.sId,
                                  ) ||
                                  activeUser.isEmpty
                              ? Center(
                                  child: basicIcon(FontAwesomeIcons.user),
                                )
                              : !activeUser
                                      .firstWhere(
                                        (element) =>
                                            element.userId != userDetails.sId,
                                      )
                                      .videoEnabled
                                  ? const Center(
                                      child: ProfileImageWidget(),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: VideoView(
                                          meetingParticipant:
                                              activeUser.firstWhere(
                                        (element) =>
                                            element.userId != userDetails.sId,
                                      )),
                                    ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class ChessBox extends StatelessWidget {
  final bool isBlack;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;
  const ChessBox(
      {super.key,
      required this.isBlack,
      this.piece,
      required this.isSelected,
      this.onTap,
      required this.isValidMove});

  @override
  Widget build(BuildContext context) {
    Color boardcolor = theme.colorWhite;
    if (isBlack) {
      boardcolor = theme.colorBlack;
    }
    if (isValidMove) {
      boardcolor = theme.colors07.withOpacity(0.8);
    }
    if (isSelected) {
      boardcolor = theme.colors07;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: boardcolor,
        alignment: Alignment.center,
        child: piece != null
            ? basicIcon(piece!.imagePath,
                size: isSelected ? 25 : 20,
                color: isBlack ? theme.colorWhite : theme.colorBlack)
            : null,
      ),
    );
  }
}

class DeadPiece extends StatelessWidget {
  final IconData imagepath;
  const DeadPiece({
    super.key,
    required this.imagepath,
  });

  @override
  Widget build(BuildContext context) {
    return basicIcon(imagepath);
  }
}
