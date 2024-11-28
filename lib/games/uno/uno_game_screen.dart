import 'package:dyte_core/dyte_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../provider/user_provider.dart';
import '../../provider/video_call_provider.dart';
import '../../services/video_call_service.dart';
import '../../widgets/basic_scaffold.dart';

class UnoGameScreen extends StatefulWidget {
  final String roomID;
  const UnoGameScreen({super.key, required this.roomID});

  @override
  State<UnoGameScreen> createState() => _UnoGameScreenState();
}

class _UnoGameScreenState extends State<UnoGameScreen> {
  List<DyteJoinedMeetingParticipant> joinedUsers = [];
  List<DyteTextMessage> dyteMessages = [];
  VideoCallService callService = VideoCallService();

  late UserDetails user;

  init() async {
    await callService.getAuthenticate(user, widget.roomID).then(
      (value) {
        if (value != null) {
          Provider.of<VideoCallProvider>(context, listen: false)
              .callInIT(value, user);
        }
      },
    );
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 2),
      () => init(),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    user = Provider.of<UserProvider>(context).userInformation;
    joinedUsers = Provider.of<VideoCallProvider>(context).activeUsers;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BasicScafold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              width: 200,
              child: VideoView(
                isSelfParticipant: true,
              ),
            ),
            if (Provider.of<VideoCallProvider>(context).activeUsers.length > 1)
              ...List.generate(
                Provider.of<VideoCallProvider>(context).activeUsers.length,
                (index) => SizedBox(
                  height: 250,
                  width: 200,
                  child: VideoView(
                    meetingParticipant: joinedUsers
                        .where(
                          (element) => element.name != user.userName,
                        )
                        .toList()[index],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
