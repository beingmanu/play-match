import 'dart:math';

import 'package:dyte_core/dyte_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../models/user_model.dart';
import '../../provider/user_provider.dart';
import '../../screens/profile/widgets/profile_image_widget.dart';
import '../../services/video_call_service.dart';
import '../../utils/navigator_helper.dart';
import '../../utils/snackbar.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';

class TADGameScreen extends StatefulWidget {
  final String roomID;
  const TADGameScreen({super.key, required this.roomID});

  @override
  State<TADGameScreen> createState() => _TADGameScreenState();
}

class _TADGameScreenState extends State<TADGameScreen>
    with TickerProviderStateMixin
    implements
        DyteMeetingRoomEventsListener,
        DyteParticipantEventsListener,
        DyteChatEventsListener {
  final dyteClient = DyteMobileClient();
  DyteJoinedMeetingParticipant? remotePeer;

  var lastPosition = 0.0;
  var random = Random();

  late AnimationController animationController;

  bool isVideoOn = false;
  bool isAudioOn = false;

  bool isJoined = false;

  VideoCallService callService = VideoCallService();
  late UserDetails userDetails;

  @override
  void initState() {
    super.initState();
    spinbottle();
    callInit();
  }

  void leaveCall() {
    dyteClient.leaveRoom();
  }

  void callInit() async {
    dyteClient.addMeetingRoomEventsListener(this);
    dyteClient.addParticipantEventsListener(this);
    dyteClient.addChatEventsListener(this);
    userDetails =
        Provider.of<UserProvider>(context, listen: false).userInformation;

    await callService.getAuthenticate(userDetails, widget.roomID).then(
      (value) {
        if (value != null) {
          final meetingInfo = DyteMeetingInfoV2(
            authToken: value,
            enableAudio: true,
            enableVideo: true,
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  turnBottle({double? newposition}) {
    if (newposition == null) {
      var index = random.nextInt(3);
      lastPosition = [1.5, 2.0, 3.0, 2.5][index];
      lastPosition = lastPosition * 5;
      setState(() {});
    } else {
      lastPosition = newposition;
    }
  }

  spinbottle({double? newposition}) {
    if (newposition != null) {
      turnBottle(newposition: newposition);
    } else {
      turnBottle();
    }
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BasicScafold(
      title: remotePeer == null ? "Wait for the opponent..." : "",
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
          basicSpace(width: 10),
          FloatingActionButton(
            onPressed: () {
              dyteClient.chat.sendTextMessage("$lastPosition");
              setState(() {
                if (animationController.isCompleted) {
                  spinbottle();
                }
              });
            },
            backgroundColor: theme.buttonColor,
            heroTag: "play",
            child: basicIcon(FontAwesomeIcons.play),
          ),
        ],
      ),
      body: !isJoined
          ? Center(child: circleLoader())
          : Column(
              children: [
                Flexible(
                  flex: 3,
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
                            ),
                    ),
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: RotationTransition(
                          turns: Tween<double>(begin: 0.0, end: lastPosition)
                              .animate(CurvedAnimation(
                                  parent: animationController,
                                  curve: Curves.decelerate)),
                          child: Image.asset(
                            "assets/16864.png",
                            width: size.width * .2,
                          ),
                        ),
                      ),
                    )),
                Flexible(
                  flex: 3,
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
                                    meetingParticipant: remotePeer,
                                  ),
                                ),
                    ),
                  ),
                ),
              ],
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
    showToast(exception.toString());
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
    showToast(exception.toString());
    leaveCall();
  }

  @override
  void onMeetingRoomJoinStarted() {}

  @override
  void onMeetingRoomLeaveCompleted() {
    dyteClient.removeMeetingRoomEventsListener(this);
    dyteClient.removeParticipantEventsListener(this);
    dyteClient.removeChatEventsListener(this);
    navigateBack(context);
    navigateBack(context);
  }

  @override
  void onMeetingRoomLeaveStarted() {}

  @override
  void onMeetingRoomReconnectionFailed() {}

  @override
  void onNewChatMessage(DyteChatMessage message) {
    if (message.displayName != userDetails.userName) {
      DyteTextMessage textMessage = message as DyteTextMessage;

      spinbottle(newposition: double.parse(textMessage.message));
    }
  }

  @override
  void onNoActiveSpeaker() {}

  @override
  void onParticipantJoin(DyteJoinedMeetingParticipant participant) {}

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
    if (participants.active.any(
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
