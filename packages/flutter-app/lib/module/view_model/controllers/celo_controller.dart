import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/module/custom_widgets/alert_dialog.dart';
import 'package:flutter_celo_composer/module/custom_widgets/snack_bar.dart';
import 'package:flutter_celo_composer/module/models/chat_model.dart';
import 'package:flutter_celo_composer/module/services/celo_web3.dart';
import 'package:flutter_celo_composer/module/services/secure_storage.dart';
import 'package:flutter_celo_composer/module/view/screens/home_page.dart';

enum Status { init, loading, done }

class CeloChatProvider extends ChangeNotifier {
  UserSecureStorage storage = UserSecureStorage();
  CeloWeb3Helper helper = CeloWeb3Helper();
  Status createStatus = Status.init;
  Status verifyStatus = Status.init;
  Status changeStatus = Status.init;
  Status authStatus = Status.init;
  Status viewStatus = Status.init;

  List<ChatDetailModel> messages = <ChatDetailModel>[];
  List<ChatDetailModel> myMessages = <ChatDetailModel>[];

  Future<dynamic> sendChat(
      String sender, String content, dynamic context) async {
    messages.add(ChatDetailModel(
        sender: sender, content: content, timestamp: DateTime.now()));
    try {
      var response = await helper.sendChat(sender, content);
      if (response != null) {
        fetchChats(context);
      } else {
        CustomSnackbar.responseSnackbar(
            context, Colors.redAccent, 'unable to add message');
      }
    } catch (e) {
      CustomSnackbar.responseSnackbar(context, Colors.redAccent, e.toString());
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchChats(dynamic context) async {
    try {
      // String did = addCeloPrefix(data.identifier ?? '');
      viewStatus = viewStatus != Status.loading ? Status.loading : Status.done;
      if (viewStatus == Status.done) return;
      notifyListeners();
      var response = await helper.fetchMessages();
      if (response != null) {
        List<ChatDetailModel> newMessages = <ChatDetailModel>[];
        for (var i in response) {
          if (i[1].toString().isNotEmpty) {
            ChatDetailModel message = ChatDetailModel(
                sender: i[0].toString(),
                content: i[1],
                timestamp:
                    DateTime.fromMillisecondsSinceEpoch(i[2].toInt() * 1000));
            print(message.toJson());
            newMessages.add(message);
          }
        }
        messages = newMessages;
        notifyListeners();
      } else {
        CustomSnackbar.responseSnackbar(
            context, Colors.redAccent, 'Unable to get all messages');
      }
    } catch (e) {
      CustomSnackbar.responseSnackbar(context, Colors.redAccent, e.toString());
    }
  }

  Future<dynamic> fetchChat(String address, dynamic context) async {
    try {
      print('heree==== first');
      var response = await helper.fetchMessage(address);
      if (response != null) {
        List<ChatDetailModel> newMessages = <ChatDetailModel>[];
        print("Response in controller ===>>> $response");
        for (var i in response) {
          if (i[1].toString().isNotEmpty) {
            ChatDetailModel message = ChatDetailModel(
                sender: i[0].toString(),
                content: i[1],
                timestamp:
                    DateTime.fromMillisecondsSinceEpoch(i[2].toInt() * 1000));
            print(message.toJson());
            newMessages.add(message);
          }
        }
        myMessages = newMessages;
        notifyListeners();
      } else {
        CustomSnackbar.responseSnackbar(
            context, Colors.redAccent, 'Unable to get your messages');
      }
    } catch (e) {
      CustomSnackbar.responseSnackbar(context, Colors.redAccent, e.toString());
    }
  }

  Future<dynamic> authenticateUser(
      String username, String wallet, dynamic context) async {
    try {
      authStatus = authStatus != Status.loading ? Status.loading : Status.done;
      if (authStatus == Status.done) return;
      notifyListeners();
      await storage.setUserAddress(wallet);
      await storage.setUsername(username);
      await storage.setCreatedBoolean();
      authStatus = Status.done;
      notifyListeners();
      alertDialogs(
          context,
          'Save Details',
          'Your details has successfully being saved and will be displayed on your chats',
          () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute<dynamic>(
                  builder: (dynamic context) => const HomePage()),
              (route) => false));
    } catch (e) {
      authStatus = Status.done;
      notifyListeners();
      CustomSnackbar.responseSnackbar(context, Colors.redAccent, e.toString());
    }
  }
}
