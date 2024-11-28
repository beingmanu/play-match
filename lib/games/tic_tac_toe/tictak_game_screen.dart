import 'package:dyte_core/dyte_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../models/user_model.dart';
import '../../provider/user_provider.dart';
import '../../services/video_call_service.dart';
import '../../utils/navigator_helper.dart';
import '../../utils/snackbar.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';
import '../../screens/profile/widgets/profile_image_widget.dart';

class TTTGameScreen extends StatefulWidget {
  final String roomID;
  const TTTGameScreen({super.key, required this.roomID});

  @override
  State<TTTGameScreen> createState() => _TTTGameScreenState();
}

class _TTTGameScreenState extends State<TTTGameScreen>
    with TickerProviderStateMixin
    implements
        DyteMeetingRoomEventsListener,
        DyteParticipantEventsListener,
        DyteChatEventsListener {
  final dyteClient = DyteMobileClient();
  DyteJoinedMeetingParticipant? remotePeer;
  bool isVideoOn = false;
  bool isAudioOn = false;
  bool isJoined = false;

  VideoCallService callService = VideoCallService();
  late UserDetails userDetails;

  List<String> displayExOh = ['', '', '', '', '', '', '', '', ''];
  int boxCount = 0;
  int exScore = 0;
  int ohScore = 0;
  bool localUserTurn = false;

  String localSymbol = "";
  late String username;

  @override
  void initState() {
    super.initState();

    callInit();
  }

  void leaveCall() {
    dyteClient.leaveRoom();
  }

  sendMessage() {
    dyteClient.chat.sendTextMessage(displayExOh.toString());
  }

  toggleVideo() {
    if (isVideoOn) {
      dyteClient.localUser.disableVideo();
    } else {
      dyteClient.localUser.enableVideo();
    }
    Future.delayed(const Duration(seconds: 1)).then(
      (value) {
        setState(() => isVideoOn = !isVideoOn);
      },
    );
  }

  toggleAudio() {
    Future(
      () {
        if (isAudioOn) {
          dyteClient.localUser.disableAudio();
        } else {
          dyteClient.localUser.enableAudio();
        }
      },
    ).then(
      (value) {
        setState(() => isAudioOn = !isAudioOn);
      },
    );
  }

  void callInit() async {
    dyteClient.addMeetingRoomEventsListener(this);
    dyteClient.addParticipantEventsListener(this);
    dyteClient.addChatEventsListener(this);
    userDetails =
        Provider.of<UserProvider>(context, listen: false).userInformation;

    await callService.getAuthenticate(userDetails, widget.roomID).then(
      (value) {
        print("=========$value");
        if (value != null) {
          final meetingInfo = DyteMeetingInfoV2(
            authToken: value,
            enableAudio: isAudioOn,
            enableVideo: isVideoOn,
          );

          try {
            dyteClient.init(meetingInfo);
          } catch (e) {
            showToast(e.toString());
          }
        } else {
          leaveCall();
        }
      },
    );
  }

  checkWinner() {
    // 1st row
    if (displayExOh[0] == displayExOh[1] &&
        displayExOh[0] == displayExOh[2] &&
        displayExOh[0] != '') {
      _showWinnerDialog(displayExOh[0]);
    } else

    // checks 2nd row
    if (displayExOh[3] == displayExOh[4] &&
        displayExOh[3] == displayExOh[5] &&
        displayExOh[3] != '') {
      _showWinnerDialog(displayExOh[3]);
    } else

// checks 3rd row
    if (displayExOh[6] == displayExOh[7] &&
        displayExOh[6] == displayExOh[8] &&
        displayExOh[6] != '') {
      _showWinnerDialog(displayExOh[6]);
    } else

    // 1st column
    if (displayExOh[0] == displayExOh[3] &&
        displayExOh[0] == displayExOh[6] &&
        displayExOh[0] != '') {
      _showWinnerDialog(displayExOh[0]);
    } else

    // checks 2nd column
    if (displayExOh[1] == displayExOh[4] &&
        displayExOh[1] == displayExOh[7] &&
        displayExOh[1] != '') {
      _showWinnerDialog(displayExOh[1]);
    } else

// checks 3rd column
    if (displayExOh[2] == displayExOh[5] &&
        displayExOh[2] == displayExOh[8] &&
        displayExOh[2] != '') {
      _showWinnerDialog(displayExOh[2]);
    } else

    // checks 1st diagonal
    if (displayExOh[0] == displayExOh[4] &&
        displayExOh[0] == displayExOh[8] &&
        displayExOh[0] != '') {
      _showWinnerDialog(displayExOh[0]);
    } else

    // checks 2nd diagonal
    if (displayExOh[2] == displayExOh[4] &&
        displayExOh[2] == displayExOh[6] &&
        displayExOh[2] != '') {
      _showWinnerDialog(displayExOh[2]);
    } else if (boxCount == 9) {
      _showDrawDialog();
    }
  }

  _showWinnerDialog(String winner) {
    if (winner == "X") {
      exScore++;
    } else if (winner == "O") {
      ohScore++;
    }
    if (localSymbol == winner) {
      showToast(
        "You Won. Let's continue this winning streak.",
      );
      localUserTurn = true;
    } else {
      showToast(
        "You Lost, All the best for next round.",
      );
      localUserTurn = false;
    }
    Future.delayed(const Duration(seconds: 1), () {
      _clearBoard();
    });
  }

  _showDrawDialog() {
    showToast(
      "Game Draw, All the best for next round.",
    );
    Future.delayed(const Duration(seconds: 1), () {
      _clearBoard();
    });
  }

  _clearBoard() {
    boxCount = 0;
    displayExOh = ['', '', '', '', '', '', '', '', ''];
    setState(() {});
  }

  tapped(int index) {
    if (!localUserTurn) {
      return;
    }
    if (displayExOh[index] != '') {
      return;
    }

    if (localUserTurn) {
      displayExOh[index] = localSymbol;
    }
    sendMessage();
    boxCount = displayExOh.where((p0) => p0 != "").length;
    setState(() => localUserTurn = !localUserTurn);

    checkWinner();
  }

  assignSymbol() {
    List<String> peer = [dyteClient.localUser.userId, remotePeer!.userId];
    peer.sort();
    if (peer.indexOf(dyteClient.localUser.userId) == 0) {
      localSymbol = "O";
      localUserTurn = true;
    } else {
      localSymbol = "X";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasicScafold(
      action: [
        TextButton(onPressed: () => leaveCall(), child: myText("Leave"))
      ],
      floatButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => toggleVideo(),
            backgroundColor: theme.buttonColor,
            heroTag: "Video",
            child: basicIcon(isVideoOn
                ? FontAwesomeIcons.video
                : FontAwesomeIcons.videoSlash),
          ),
          basicSpace(width: 10),
          FloatingActionButton(
            onPressed: () => toggleAudio(),
            backgroundColor: theme.buttonColor,
            heroTag: "Audio",
            child: basicIcon(isAudioOn
                ? FontAwesomeIcons.microphone
                : FontAwesomeIcons.microphoneSlash),
          ),
        ],
      ),
      body: !isJoined
          ? Center(child: circleLoader())
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FittedBox(
                              child: Text(
                                "Player X",
                                style: theme.title01,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "$exScore",
                              style: theme.title01,
                            ),
                          ]),
                    ),
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FittedBox(
                              child: Text(
                                "Player O",
                                style: theme.title01,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "$ohScore",
                              style: theme.title01,
                            ),
                          ]),
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: Expanded(
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
                                  )
                            // : circleLoader(),
                            ),
                      ),
                    ),
                    Flexible(
                      child: Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          height: 200,
                          decoration: BoxDecoration(
                              border: Border.all(color: theme.colors03),
                              borderRadius: BorderRadius.circular(15)),
                          child: remotePeer == null
                              ? Center(
                                  child: basicIcon(FontAwesomeIcons.user),
                                )
                              : !remotePeer!.videoEnabled
                                  ? const Center(
                                      child: ProfileImageWidget(),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: VideoView(
                                          meetingParticipant: remotePeer),
                                    ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: remotePeer == null
                      ? const SizedBox()
                      : Text(
                          (localUserTurn)
                              ? "It's Your Turn"
                              : "Waiting for opponent to play",
                          textAlign: TextAlign.center,
                          style: theme.title01!.copyWith(color: Colors.blue),
                        ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                      child: remotePeer == null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Waiting for opponent to join 😄",
                                textAlign: TextAlign.center,
                                style: theme.subtitle01!
                                    .copyWith(color: Colors.blue),
                              ),
                            )
                          : GridView.builder(
                              itemCount: 9,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () => tapped(index),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey[700]!)),
                                    child: Center(
                                      child: Text(
                                        displayExOh[index],
                                        style: theme.title01!.copyWith(
                                            color: theme.colors01,
                                            fontSize: 26),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                ),
                basicSpace(height: 80)
              ],
            ),
    );
  }

  showtBox(String? text) {
    return showDialog(
      context: context,
      builder: (context) => Card(
        child: Column(
          children: [
            myText(text ?? ""),
            TextButton(onPressed: () {}, child: myText("Leave"))
          ],
        ),
      ),
    );
  }

  @override
  void onActiveParticipantsChanged(List<DyteJoinedMeetingParticipant> active) {}

  @override
  void onActiveSpeakerChanged(DyteJoinedMeetingParticipant participant) {}

  @override
  void onActiveTabUpdate(DyteActiveTab? activeTab) {}

  @override
  void onAudioUpdate(
      bool audioEnabled, DyteJoinedMeetingParticipant participant) {}

  @override
  void onChatUpdates(List<DyteChatMessage> messages) {}

  @override
  void onConnectedToMeetingRoom() {}

  @override
  void onConnectingToMeetingRoom() {}

  @override
  void onDisconnectedFromMeetingRoom(String reason) {}

  @override
  void onMeetingEnded() {}

  @override
  void onMeetingInitCompleted() {
    dyteClient.joinRoom();
    dyteClient.localUser.setDisplayName(userDetails.userName!);
    isAudioOn = isAudioOn;
    isVideoOn = isVideoOn;
    setState(() {});
  }

  @override
  void onMeetingInitFailed(Exception exception) {
    showToast("Something went wrong");
    print("=====${exception.toString()}");
    leaveCall();
  }

  @override
  void onMeetingInitStarted() {}

  @override
  void onMeetingRoomConnectionFailed() {
    showToast("Something went wrong");
    print("=====roomconnection dailed====");
    leaveCall();
  }

  @override
  void onMeetingRoomDisconnected() {}

  @override
  void onMeetingRoomJoinCompleted() {
    isJoined = true;
    setState(() {});
  }

  @override
  void onMeetingRoomJoinFailed(Exception exception) {
    showToast("========something went wrong");
    print("=====${exception.toString()}");
    leaveCall();
  }

  @override
  void onMeetingRoomJoinStarted() {}

  @override
  void onMeetingRoomLeaveCompleted() {
    dyteClient.removeMeetingRoomEventsListener(this);
    dyteClient.removeParticipantEventsListener(this);
    dyteClient.removeChatEventsListener(this);
    dyteClient.cleanAllNativeListeners();

    navigateBack(context);
    navigateBack(context);
  }

  @override
  void onMeetingRoomLeaveStarted() {}

  @override
  void onMeetingRoomReconnectionFailed() {}

  @override
  void onNewChatMessage(DyteChatMessage message) {
    if (message.userId == dyteClient.localUser.userId) {
      return;
    }
    DyteTextMessage textMessage = message as DyteTextMessage;
    List<String> temp = textMessage.message
        .replaceFirst("[", "")
        .replaceFirst("]", "")
        .split(", ");
    displayExOh = temp;
    setState(() => localUserTurn = !localUserTurn);
    boxCount = displayExOh.where((p0) => p0 != "").length;
    checkWinner();
  }

  @override
  void onNoActiveSpeaker() {}

  @override
  void onParticipantJoin(DyteJoinedMeetingParticipant participant) {
    print("====onPjoin====${participant.name}");
    if (remotePeer != null) {
      assignSymbol();
    }
  }

  @override
  void onParticipantLeave(DyteJoinedMeetingParticipant participant) {
    if (remotePeer != null) {
      if (participant.name == remotePeer!.name) {
        remotePeer = null;
        setState(() {});
      }
    }
  }

  @override
  void onParticipantPinned(DyteJoinedMeetingParticipant participant) {}

  @override
  void onParticipantUnpinned(DyteJoinedMeetingParticipant participant) {}

  @override
  void onReconnectedToMeetingRoom() {}

  @override
  void onReconnectingToMeetingRoom() {}

  @override
  void onScreenShareEnded(DyteJoinedMeetingParticipant participant) {}

  @override
  void onScreenShareStarted(DyteJoinedMeetingParticipant participant) {}

  @override
  void onScreenSharesUpdated() {}

  @override
  void onUpdate(DyteParticipants participants) {
    if (participants.joined.any(
      (element) => element.name == userDetails.userName,
    )) {
      setState(() => isJoined = true);
    }
    for (var element in participants.joined) {
      if (element.name != userDetails.userName) {
        setState(() => remotePeer = element);
      }
    }
  }

  @override
  void onVideoUpdate(
      bool videoEnabled, DyteJoinedMeetingParticipant participant) {
    if (participant.name != userDetails.userName) {
      setState(() => remotePeer = participant);
    }
  }
}
