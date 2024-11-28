import 'package:dyte_core/dyte_core.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/video_call_service.dart';
import '../utils/navigator_helper.dart';
import '../utils/snackbar.dart';

class VideoCallProvider
    with ChangeNotifier
    implements
        DyteMeetingRoomEventsListener,
        DyteParticipantEventsListener,
        DyteChatEventsListener {
  late DyteMobileClient dyteClient;

  List<DyteJoinedMeetingParticipant> activeUsers = [];

  List<DyteTextMessage> dyteMessages = [];

  bool isVideoOn = false;
  bool isAudioOn = false;
  bool isJoined = false;

  VideoCallService callService = VideoCallService();

  late UserDetails user;

  leaveCall(BuildContext _) {
    isJoined = false;
    activeUsers = [];
    dyteMessages = [];
    isVideoOn = false;
    isAudioOn = false;
    try {
      dyteClient.leaveRoom();
    } catch (e) {
      print("leave error\n$e");
    }

    notifyListeners();
    navigateBack(_);
    navigateBack(_);
  }

  sendMessage(String message) {
    dyteClient.chat.sendTextMessage(message);
    dyteMessages.add(DyteTextMessage(
        message: message,
        displayName: user.userName!,
        read: true,
        type: DyteMessageType.text,
        pluginId: null,
        time: DateTime.now().toIso8601String(),
        userId: user.sId!));
    notifyListeners();
  }

  callInIT(String token, UserDetails usernew) async {
    dyteClient = DyteMobileClient();
    dyteClient.addMeetingRoomEventsListener(this);
    dyteClient.addParticipantEventsListener(this);
    dyteClient.addChatEventsListener(this);

    final meetingInfo = DyteMeetingInfoV2(
      authToken: token,
      enableAudio: isAudioOn,
      enableVideo: isVideoOn,
    );
    user = usernew;
    dyteClient.init(meetingInfo);
    // try {} catch (e) {
    //   showToast("Call init error!\n${e.toString()}");
    // }
    notifyListeners();
  }

  toggleAudio() {
    if (isAudioOn) {
      dyteClient.localUser.disableAudio();
    } else {
      dyteClient.localUser.enableAudio();
    }
    isAudioOn = !isAudioOn;
    notifyListeners();
  }

  toggleVideo() {
    if (isVideoOn) {
      dyteClient.localUser.disableVideo();
    } else {
      dyteClient.localUser.enableVideo();
    }
    isVideoOn = !isVideoOn;
    notifyListeners();
  }

  @override
  void onActiveParticipantsChanged(List<DyteJoinedMeetingParticipant> active) {
    notifyListeners();
  }

  @override
  void onActiveSpeakerChanged(DyteJoinedMeetingParticipant participant) {
    notifyListeners();
  }

  @override
  void onActiveTabUpdate(DyteActiveTab? activeTab) {
    notifyListeners();
  }

  @override
  void onAudioUpdate(
      bool audioEnabled, DyteJoinedMeetingParticipant participant) {
    int index = activeUsers.indexWhere(
      (element) => element.id == participant.id,
    );
    activeUsers[index] = participant;
    notifyListeners();
  }

  @override
  void onChatUpdates(List<DyteChatMessage> messages) {
    notifyListeners();
  }

  @override
  void onConnectedToMeetingRoom() {
    notifyListeners();
  }

  @override
  void onConnectingToMeetingRoom() {
    notifyListeners();
  }

  @override
  void onDisconnectedFromMeetingRoom(String reason) {
    notifyListeners();
  }

  @override
  void onMeetingEnded() {
    showToast("Meeting Ended");
    notifyListeners();
  }

  @override
  void onMeetingInitCompleted() {
    dyteClient.joinRoom();
    dyteClient.localUser.setDisplayName(user.userName!);
    notifyListeners();
  }

  @override
  void onMeetingInitFailed(Exception exception) {
    showToast("on init failed!\n${exception.toString()}");

    notifyListeners();
  }

  @override
  void onMeetingInitStarted() {
    notifyListeners();
  }

  @override
  void onMeetingRoomConnectionFailed() {
    showToast("onMeetingRoomConnectionFailed");

    notifyListeners();
  }

  @override
  void onMeetingRoomDisconnected() {
    showToast("onMeetingRoomDisconnected");
    notifyListeners();
  }

  @override
  void onMeetingRoomJoinCompleted() {
    isJoined = true;

    showToast("Joined");
    notifyListeners();
  }

  @override
  void onMeetingRoomJoinFailed(Exception exception) {
    showToast("====roomjoinedfailed==${exception.toString()}");
    isJoined = false;
    notifyListeners();
  }

  @override
  void onMeetingRoomJoinStarted() {
    notifyListeners();
  }

  @override
  void onMeetingRoomLeaveCompleted() {
    dyteClient.removeMeetingRoomEventsListener(this);
    dyteClient.removeParticipantEventsListener(this);
    dyteClient.removeChatEventsListener(this);
    dyteClient.cleanAllNativeListeners();
    showToast("Leave complete");

    notifyListeners();
  }

  @override
  void onMeetingRoomLeaveStarted() {
    notifyListeners();
  }

  @override
  void onMeetingRoomReconnectionFailed() {
    showToast("on Meeting Room Reconnection Failed");
    notifyListeners();
  }

  @override
  void onNewChatMessage(DyteChatMessage message) {
    DyteTextMessage textmessage = message as DyteTextMessage;

    if (textmessage.displayName != user.userName) {
      dyteMessages.add(textmessage);
    }
    notifyListeners();
  }

  @override
  void onNoActiveSpeaker() {
    notifyListeners();
  }

  @override
  void onParticipantJoin(DyteJoinedMeetingParticipant participant) {
    activeUsers.add(participant);
    notifyListeners();
  }

  @override
  void onParticipantLeave(DyteJoinedMeetingParticipant participant) {
    activeUsers.remove(participant);
    notifyListeners();
  }

  @override
  void onParticipantPinned(DyteJoinedMeetingParticipant participant) {
    notifyListeners();
  }

  @override
  void onParticipantUnpinned(DyteJoinedMeetingParticipant participant) {
    notifyListeners();
  }

  @override
  void onReconnectedToMeetingRoom() {
    showToast("on Reconnected To Meeting Room");
    notifyListeners();
  }

  @override
  void onReconnectingToMeetingRoom() {
    showToast("on Reconnecting To Meeting Room");
    notifyListeners();
  }

  @override
  void onScreenShareEnded(DyteJoinedMeetingParticipant participant) {
    notifyListeners();
  }

  @override
  void onScreenShareStarted(DyteJoinedMeetingParticipant participant) {
    notifyListeners();
  }

  @override
  void onScreenSharesUpdated() {
    notifyListeners();
  }

  @override
  void onUpdate(DyteParticipants participants) {
    activeUsers = participants.active;
    print("=====act=====${participants.active.length}");
    for (var element in participants.active) {
      print("====act==${element.id}===${element.name}");
    }
    print("=====join=====${participants.joined.length}");
    for (var element in participants.joined) {
      print("===join===${element.id}===${element.name}");
    }

    notifyListeners();
  }

  @override
  void onVideoUpdate(
      bool videoEnabled, DyteJoinedMeetingParticipant participant) {
    int index = activeUsers.indexWhere(
      (element) => element.id == participant.id,
    );
    activeUsers[index] = participant;
    notifyListeners();
  }
}
