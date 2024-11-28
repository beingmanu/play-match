import 'package:flutter/material.dart';

import '../../main.dart';
import '../../utils/navigator_helper.dart';
import '../../utils/snackbar.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';
import '../../widgets/main_button.dart';
import 'otp_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool isLoading = false;

  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BasicScafold(
      title: "Welcome!",
      bottomBar: [
        MainButton(
          isLoading: isLoading,
          title: "Get OTP",
          onTap: () {
            if (phoneController.text.length != 10) {
              showToast("Oops, that's not a mobile number! Try again.");
              return;
            }

            navigateTo(context, OTPScreen(phone: "+91${phoneController.text}"));
          },
        )
      ],
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: SizedBox(
                  height: size.width, child: Image.asset("assets/bird.png")),
            ),
            const Spacer(),
            myText("Gimme your digits!",
                style: theme.subtitle02!.copyWith(fontWeight: FontWeight.w800),
                align: TextAlign.start,
                padding: 0),
            myText("(We won't spam, promise!)",
                style: theme.subtitle03, align: TextAlign.start, padding: 0),
            basicSpace(height: 30),
            textTileLogin(size, phoneController, "Mobile Number"),
            basicSpace(height: 30),
            myText("Unlock the good stuff! Hit us with your number",
                style: theme.subtitle02, align: TextAlign.start),
            basicSpace(height: 80),
          ],
        ),
      ),
    );
  }
}

Widget textTileLogin(
        Size size, TextEditingController controller, String hintText) =>
    Container(
      decoration: BoxDecoration(
          border: Border.all(color: theme.colorCompanion02),
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          prefixText: "+91  ",
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: theme.subtitle02,
        ),
      ),
    );
