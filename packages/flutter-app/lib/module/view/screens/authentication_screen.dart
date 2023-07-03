import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/module/custom_widgets/snack_bar.dart';
import 'package:flutter_celo_composer/module/services/secure_storage.dart';
import 'package:flutter_celo_composer/module/view/screens/home_page.dart';
import 'package:flutter_celo_composer/module/view/widgets/custom_button.dart';
import 'package:flutter_celo_composer/module/view/widgets/custom_textfield.dart';
import 'package:flutter_celo_composer/module/view_model/controllers/celo_controller.dart';
import 'package:flutter_celo_composer/module/view_model/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationScreen extends ConsumerStatefulWidget {
  const AuthenticationScreen({super.key, this.isAuth = true});
  final bool isAuth;

  @override
  ConsumerState<AuthenticationScreen> createState() =>
      _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  TextEditingController walletController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  String? text;
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: widget.isAuth
          ? null
          : AppBar(
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'Update Details',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.04, right: size.width * 0.04, top: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset('assets/images/logo.png',
                        height: 60, width: 90),
                    const SizedBox(width: 10),
                    const Text(
                      'Chat DApp',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black54),
                    )
                  ],
                ),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Enter your details to register your address an username on the chat dApp.',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        text: 'Username',
                        controller: usernameController,
                        hint: 'enter your username',
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        text: 'Wallet Address',
                        controller: walletController,
                        hint: 'enter your wallet address',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                CustomButtonWidget(
                  text: ref.watch(celoProvider).authStatus == Status.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Save Details',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                  onPressed: () async {
                    if (walletController.text.trim().isEmpty ||
                        usernameController.text.trim().isEmpty) {
                      CustomSnackbar.responseSnackbar(context, Colors.redAccent,
                          'Fill the required fields..');
                      return;
                    }
                    await ref.read(celoProvider).authenticateUser(
                        usernameController.text.trim(),
                        walletController.text.trim(),
                        context);
                  },
                ),
                const SizedBox(height: 10),
                Center(
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'Already registered ? ',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Proceed to Home',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    await UserSecureStorage()
                                        .setCreatedBoolean();
                                    if (!mounted) return;
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                            builder: (_) => const HomePage()));
                                  })
                          ])),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    walletController.dispose();
    usernameController.dispose();
    super.dispose();
  }
}
