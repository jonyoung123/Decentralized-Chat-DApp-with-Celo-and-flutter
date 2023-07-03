import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/module/view/screens/authentication_screen.dart';
import 'package:flutter_celo_composer/module/view/screens/chat_screen.dart';
import 'package:flutter_celo_composer/module/view/screens/view_message.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey actionKey = GlobalKey();
  int selectedIndex = 0;
  List<Widget> screens = <Widget>[const ChatScreen(), const ViewMessagePage()];

  void _onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Celo Chat dApp',
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          IconButton(
              key: actionKey,
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromRect(
                    getWidgetBounds(actionKey),
                    Offset.zero & MediaQuery.of(context).size,
                  ),
                  items: <PopupMenuItem<String>>[
                    PopupMenuItem<String>(
                      value: 'change',
                      enabled: false,
                      child: GestureDetector(
                        child: const Text(
                          'Update Detail',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute<dynamic>(
                                  builder: (dynamic context) =>
                                      const AuthenticationScreen(
                                        isAuth: false,
                                      )));
                        },
                      ),
                    ),
                  ],
                );
              },
              icon: const Icon(Icons.more_vert))
        ],
      ),
      backgroundColor: Colors.white,
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Chats',
            icon: Icon(Icons.chat),
          ),
          BottomNavigationBarItem(
            label: 'My messages',
            icon: Icon(Icons.chat_bubble_rounded),
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.white,
        selectedLabelStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        elevation: 12,
        showUnselectedLabels: true,
        onTap: _onTapped,
      ),
    );
  }

  Rect getWidgetBounds(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    return offset & renderBox.size;
  }
}
