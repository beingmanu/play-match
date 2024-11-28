import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;

import '../../main.dart';
import '../../utils/navigator_helper.dart';
import '../../widgets/basic_scaffold.dart';
import '../../widgets/basic_widget.dart';
import '../../widgets/main_button.dart';
import 'login_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int currenttab = 0;

  PageController? pageViewController;

  var dataList = [
    {
      "image": "assets/intro1.svg",
      "title": "Discount on every Purchase",
      "subtitle":
          "Lorem ipsum dolor sit amet consectetur. Justo amet leo tristique montes molestie id. Congue vel nunc amet enim fermentum. Velit consequat enim varius"
    },
    {
      "image": "assets/intro2.svg",
      "title": "Discount on every Purchase",
      "subtitle":
          "Lorem ipsum dolor sit amet consectetur. Justo amet leo tristique montes molestie id. Congue vel nunc amet enim fermentum. Velit consequat enim varius"
    },
    {
      "image": "assets/intro3.svg",
      "title": "Discount on every Purchase",
      "subtitle":
          "Lorem ipsum dolor sit amet consectetur. Justo amet leo tristique montes molestie id. Congue vel nunc amet enim fermentum. Velit consequat enim varius"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return BasicScafold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageViewController ??= PageController(
                initialPage: currenttab,
              ),
              scrollDirection: Axis.horizontal,
              onPageChanged: (value) {
                setState(() {
                  currenttab = value;
                });
              },
              children: [
                ...List.generate(
                    3,
                    (index) => IntroWidget(
                          title: dataList[index]["title"]!,
                          subtitle: dataList[index]["subtitle"]!,
                          svgImage: dataList[index]["image"]!,
                        )),
              ],
            ),
          ),
          Center(
            child: smooth_page_indicator.SmoothPageIndicator(
              controller:
                  pageViewController ?? PageController(initialPage: currenttab),
              count: 3,
              axisDirection: Axis.horizontal,
              onDotClicked: (i) {
                currenttab = i;
                setState(() {});
                pageViewController!.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              },
              effect: smooth_page_indicator.ExpandingDotsEffect(
                expansionFactor: 2,
                spacing: 8,
                radius: 10,
                dotWidth: 10,
                dotHeight: 10,
                dotColor: theme.textColorDefault!,
                activeDotColor: theme.buttonColor!,
                paintStyle: PaintingStyle.fill,
              ),
            ),
          ),
          MainButton(
            isLoading: false,
            title: "Next",
            onTap: () => navigateTo(context, const IntroThirdWidget()),
          )
        ],
      ),
    );
  }
}

class IntroWidget extends StatelessWidget {
  final String svgImage;
  final String title;
  final String subtitle;
  const IntroWidget({
    super.key,
    required this.svgImage,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        myText(title, style: theme.subtitle01),
        Expanded(child: SvgPicture.asset(svgImage)),
        myText(subtitle, style: theme.subtitle01)
      ],
    );
  }
}

class IntroThirdWidget extends StatelessWidget {
  const IntroThirdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BasicScafold(
      bottomBar: [
        MainButton(
          isLoading: false,
          title: "Next",
          onTap: () => navigateTo(context, const LogInScreen()),
        )
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: ThirdPainter(),
              ),
              Positioned(
                top: 10,
                left: 100,
                child: SizedBox(
                    height: size.width * .5,
                    width: size.width * .5,
                    child: Image.asset("assets/bird.png")),
              ),
            ],
          )),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                myText("Buckle up,",
                    style:
                        theme.text20Bold!.copyWith(fontSize: size.width * .12),
                    padding: 0,
                    align: TextAlign.start),
                myText("it's gonna be lit!",
                    style:
                        theme.text20Bold!.copyWith(fontSize: size.width * .12),
                    padding: 0,
                    align: TextAlign.start),
                myText("Find Your Ride-or-Die!",
                    style: theme.subtitle01,
                    padding: 0,
                    align: TextAlign.start),
                basicSpace(height: 50)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ThirdPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = theme.colors01
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(size.width, 0);

    path.lineTo(size.width, size.height * .7);

    path.quadraticBezierTo(
        size.width * .55, size.height * .75, size.width * .6, size.height * .4);

    path.quadraticBezierTo(
        size.width * .15, size.height * .3, size.width * .4, 0);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ThirdPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(ThirdPainter oldDelegate) => false;
}
