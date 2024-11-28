// import 'package:dyte_core/dyte_core.dart';
// import 'package:flutter/material.dart';

// class VideoCallProvider extends ChangeNotifier {
//   List<DyteJoinedMeetingParticipant> participantsList = [];

//   void updateUsersList(List<DyteJoinedMeetingParticipant> list) {
//     participantsList = list;
//     notifyListeners();
//   }

//   void updateOneUser(DyteJoinedMeetingParticipant participant) {
//     int indexToUpdate = participantsList
//         .indexWhere((element) => element.name == participant.name);
//     participantsList[indexToUpdate] = participant;
//     notifyListeners();
//   }

//   void joinUser(DyteJoinedMeetingParticipant participant) {
//     participantsList.add(participant);
//     notifyListeners();
//   }

//   void leaveUser(DyteJoinedMeetingParticipant participant) {
//     participantsList.remove(participant);
//     notifyListeners();
//   }

//   void clearList() {
//     participantsList = [];
//     notifyListeners();
//   }
// }
