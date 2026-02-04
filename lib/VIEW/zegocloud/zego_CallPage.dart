// import 'package:flutter/cupertino.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class CallPage extends StatelessWidget {
//   const CallPage({

//     Key? key,
//     required this.callID,
//     required this.userID, // ADD THIS
//     required this.userName, // ADD THIS

//   }) : super(key: key);

//   final String callID;
//   final String userID; // CHANGE FROM FINAL DECLARATION
//   final String userName; // CHANGE FROM FINAL DECLARATION

//   @override
//   Widget build(BuildContext context) {
//     return ZegoUIKitPrebuiltCall(
//       appID:
//           1253586825, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
//       appSign:
//           "08be57d145c3855da96f0643f13ad0aa8ead83ad7fb51a51c18eb1777bfa54b6", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
//       userID: userID,
//       userName: userName,
//       callID: callID,
//       // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
//       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
//     );
//   }
// }
