import 'package:donate/VIEW/zegocloud/zego_CallPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class VideoCallHelper {
  // Initialize video call for current user
  static void initVideoCall() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: 1666014796,
        appSign:
            "dde62f5bc7593bfcba9fb7b3059e8b1c075838d979e53ba89ef169112fdce4ce",
        userID: user.uid, // Firebase UID
        userName: user.displayName ?? user.email ?? "User",
        plugins: [ZegoUIKitSignalingPlugin()],
      );
    }
  }

  // Get current user's UID
  static String? getCurrentUID() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  // Get current user's name
  static String getCurrentUserName() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? user?.email ?? "User";
  }

  // Start a video call
  static void startCall({
    required BuildContext context,
    required String otherUserId,
    required String otherUserName,
  }) {
    String? myId = getCurrentUID();
    String myName = getCurrentUserName();

    if (myId == null) return;

    String callID = "call_${myId}_${otherUserId}";

    // Navigate to call page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CallPage(callID: callID, userID: myId, userName: myName),
      ),
    );
  }
}
