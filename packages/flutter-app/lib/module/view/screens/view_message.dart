import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_celo_composer/module/custom_widgets/format_date.dart';
import 'package:flutter_celo_composer/module/models/chat_model.dart';
import 'package:flutter_celo_composer/module/services/secure_storage.dart';
import 'package:flutter_celo_composer/module/view_model/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewMessagePage extends ConsumerStatefulWidget {
  const ViewMessagePage({super.key});

  @override
  ConsumerState<ViewMessagePage> createState() => _ViewMessagePageState();
}

class _ViewMessagePageState extends ConsumerState<ViewMessagePage> {
  String? username;
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      String address = await UserSecureStorage().getUserAddress();
      username = await UserSecureStorage().getUsername();
      setState(() {});
      if (!mounted) return;
      ref.read(celoProvider).fetchChat(address, context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ListView.separated(
            separatorBuilder: (_, __) => const SizedBox(height: 15),
            itemCount: ref.watch(celoProvider).myMessages.length,
            itemBuilder: (dynamic context, int index) {
              ChatDetailModel message =
                  ref.read(celoProvider).myMessages[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: size.width * 0.2, left: 0),
                    child: Material(
                      elevation: 2,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(0),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      color: Colors.grey,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 10),
                          child: Column(
                            children: <Widget>[
                              Text(
                                username ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                message.content ?? '',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    convertDate(message.timestamp),
                    style: const TextStyle(fontSize: 13, color: Colors.black45),
                  ),
                ],
              );
            }),
      )),
    );
  }
}
