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
import '../../widgets/basic_container.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';

class RandomConnectPage extends StatefulWidget {
  final String token;
  const RandomConnectPage({super.key, required this.token});

  @override
  State<RandomConnectPage> createState() => _RandomConnectPageState();
}

class _RandomConnectPageState extends State<RandomConnectPage> {
  bool isJoined = false;
  bool isVideoOn = false;
  bool isAudioOn = false;
  List<DyteJoinedMeetingParticipant> activeUser = [];
  List<DyteTextMessage> dyteMessages = [];
  late UserDetails userDetails;
  bool canLeave = false;
  TextEditingController chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    gameInIT();
  }

  gameInIT() {
    Provider.of<VideoCallProvider>(context, listen: false).callInIT(
        widget.token,
        Provider.of<UserProvider>(context, listen: false).userInformation);
  }

  @override
  void didChangeDependencies() {
    userDetails = Provider.of<UserProvider>(context).userInformation;
    isJoined = Provider.of<VideoCallProvider>(context).isJoined;
    isVideoOn = Provider.of<VideoCallProvider>(context).isVideoOn;
    isAudioOn = Provider.of<VideoCallProvider>(context).isAudioOn;
    activeUser = Provider.of<VideoCallProvider>(context).activeUsers;
    dyteMessages = Provider.of<VideoCallProvider>(context).dyteMessages;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: canLeave,
      child: BasicScafold(
        body: !isJoined
            ? Center(
                child: myText("wait for Join the call"),
              )
            : Column(
                children: [
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        heroTag: "Video",
                        backgroundColor: theme.colorCompanion02,
                        mini: true,
                        onPressed: () => Provider.of<VideoCallProvider>(context,
                                listen: false)
                            .dyteClient
                            .leaveRoom(),
                        child: basicIcon(isVideoOn
                            ? FontAwesomeIcons.video
                            : FontAwesomeIcons.videoSlash),
                      ),
                      basicSpace(width: 10),
                      FloatingActionButton(
                        heroTag: "Audio",
                        mini: true,
                        backgroundColor: theme.colorCompanion02,
                        onPressed: () => Provider.of<VideoCallProvider>(context,
                                listen: false)
                            .toggleAudio(),
                        child: basicIcon(isAudioOn
                            ? FontAwesomeIcons.microphone
                            : FontAwesomeIcons.microphoneSlash),
                      ),
                      basicSpace(width: 10),
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
                  Expanded(
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Column(
                        children: [
                          ...List.generate(
                            dyteMessages.length,
                            (index) => Row(
                              mainAxisAlignment:
                                  dyteMessages[index].displayName ==
                                          userDetails.userName
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                dyteMessages[index].displayName ==
                                        userDetails.userName
                                    ? Flexible(
                                        child: BasicOutLineContainer(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            myText(
                                              dyteMessages[index].message,
                                              padding: 0,
                                              maxLine: 100,
                                            ),
                                            myText("You",
                                                padding: 0,
                                                style: theme.subtitle01,
                                                align: TextAlign.end)
                                          ],
                                        ),
                                      ))
                                    : Flexible(
                                        child: BasicFilledContainer(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              myText(
                                                dyteMessages[index].message,
                                                padding: 0,
                                                maxLine: 100,
                                              ),
                                              myText(
                                                  dyteMessages[index]
                                                      .displayName,
                                                  padding: 0,
                                                  style: theme.subtitle01,
                                                  align: TextAlign.end)
                                            ],
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  BasicOutLineContainer(
                    marginh: 10,
                    child: Row(
                      children: [
                        Flexible(
                            child: TextField(
                          controller: chatController,
                          decoration: const InputDecoration(
                              border: InputBorder.none, isDense: true),
                        )),
                        GestureDetector(
                            onTap: () {
                              if (chatController.text.isEmpty) {
                                showToast("Chat box is empty");
                                return;
                              }
                              Provider.of<VideoCallProvider>(context,
                                      listen: false)
                                  .sendMessage(chatController.text);
                              chatController.clear();
                            },
                            child: basicIcon(FontAwesomeIcons.paperPlane))
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
