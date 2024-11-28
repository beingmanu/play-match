import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../config/app_cache.dart';
import '../../main.dart';
import '../../models/user_model.dart';
import '../../provider/user_provider.dart';
import '../../services/auth_service.dart';
import '../../utils/navigator_helper.dart';
import '../../utils/snackbar.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';
import '../../widgets/main_button.dart';
import '../home/home_dashboard.dart';
import 'signup_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  const OTPScreen({
    super.key,
    required this.phone,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController codeController = TextEditingController();

  AuthService authService = AuthService();

  bool isLoading = false;
  bool isloadafteropt = false;

  String verifyId = "";

  FocusNode focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  Timer? _timer;
  int _remainingTime = 0;

  @override
  void initState() {
    super.initState();
    verifyphone();
  }

  @override
  void dispose() {
    codeController.dispose();
    focusNode.dispose();
    _timer?.cancel();
    isLoading = false;
    isloadafteropt = false;
    super.dispose();
  }

  verifyphone() async {
    setState(() {
      isLoading = true;
    });
    try {
      verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
        setState(() {
          isLoading = false;
        });
      }

      verificationFailed(FirebaseAuthException authException) {
        setState(() {
          isLoading = false;
        });
        showToast('Phone verification failed:\n$authException');
        print('Phone verification failed:$authException');

        Navigator.pop(context);
      }

      codeSent(String verificationId, int? forceResendingToken) async {
        verifyId = verificationId;
        _startTimer(60);
        setState(() {
          isLoading = false;
        });
      }

      codeAutoRetrievalTimeout(String verificationId) {
        verifyId = verificationId;
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phone,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      showToast(e.message!);
      print(e.message);
    }
  }

  void _startTimer(int time) {
    _remainingTime = time;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final focusedBorderColor = theme.buttonColor;

    final defaultPinTheme = PinTheme(
      width: 45,
      height: 45,
      textStyle: theme.subtitle01,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: theme.textColorDefault!),
      ),
    );
    return BasicScafold(
      title: "Verify your number",
      bottomBar: [
        MainButton(
            isLoading: isloadafteropt,
            title: "Log in",
            onTap: () async {
              if (isloadafteropt) {
                return;
              }
              if (codeController.text.length == 6) {
                setState(() {
                  isloadafteropt = true;
                });

                await authService
                    .firebasSignIN(verifyId, codeController.text)
                    .then((value) async {
                  if (value == null) {
                    setState(() => isloadafteropt = false);
                  }
                  if (value![0] == true) {
                    setState(() => isloadafteropt = false);
                    removeAllAndPush(context, const SignUpScreen());
                  } else {
                    final User user = value[1];
                    await authService
                        .userLogin(user.phoneNumber!
                            .substring(user.phoneNumber!.length - 10))
                        .then((value) async {
                      if (value == "NewUser") {
                        navigateTo(context, const SignUpScreen());
                      }
                      if (value is UserDetails) {
                        AppCache().doLogin(value.token!);

                        Provider.of<UserProvider>(context, listen: false)
                            .setUser(value);

                        removeAllAndPush(context, const HomeDashboard());
                      }
                      setState(() => isloadafteropt = false);
                    });
                  }
                });
              } else {
                setState(() => isloadafteropt = false);
                showToast("Please enter valid OTP");
              }
            })
      ],
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SvgPicture.asset("assets/splash.svg"),
          basicSpace(height: 40),
          myText("We Send OTP Code to Verify Your Number",
              style: theme.subtitle01, align: TextAlign.center),
          myText(widget.phone,
              style: theme.subtitle02, padding: 0, align: TextAlign.center),
          basicSpace(height: 40),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput(
              controller: codeController,
              focusNode: focusNode,
              length: 6,
              enabled: !isloadafteropt,
              // listenForMultipleSmsOnAndroid: true,
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => const SizedBox(width: 8),
              // validator: (value) {
              //   return value == '2222' ? null : 'Pin is incorrect';
              // },
              // hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {},
              onChanged: (value) {},
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: focusedBorderColor!),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: theme.colorBgDialog,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
          basicSpace(height: 40),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              myText("Didn't receive an OTP? ", style: theme.subtitle02),
              _remainingTime != 0
                  ? Text(
                      "00:$_remainingTime",
                      style: theme.subtitle03,
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });
                        verifyphone();
                      },
                      child: myText("Resend OTP", style: theme.subtitle02)),
            ],
          ),
        ],
      ),
    );
  }
}
