import 'package:flutter/cupertino.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  const CallPage({
    Key? key,
    required this.callID,
    required this.userID, // ADD THIS
    required this.userName, // ADD THIS
  }) : super(key: key);

  final String callID;
  final String userID; // CHANGE FROM FINAL DECLARATION
  final String userName; // CHANGE FROM FINAL DECLARATION

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID:
          1666014796, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign:
          "dde62f5bc7593bfcba9fb7b3059e8b1c075838d979e53ba89ef169112fdce4ce", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: userID,
      userName: userName,
      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
