import 'package:classroom/blocs/auth_bloc.dart';
import 'package:classroom/screens/onboarding/single_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.easeInOut;

  nextFunction() {
    _pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  previousFunction() {
    _pageController.previousPage(duration: _kDuration, curve: _kCurve);
  }

  onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc ab = Provider.of<AuthenticationBloc>(context);

    Size size = MediaQuery.of(context).size;
    SmoothPageIndicator indicator = SmoothPageIndicator(
      controller: _pageController,
      count: 4,
      effect: const JumpingDotEffect(
        activeDotColor: Colors.white,
        paintStyle: PaintingStyle.stroke,
        strokeWidth: 2,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: PageView(
              controller: _pageController,
              onPageChanged: onChangedFunction,
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                SinglePage(
                  imagePath: "assets/images/onboard1.png",
                  title: "Welcome to Classroom",
                  subtitle:
                      "An online collaboration platform for teachers and their students that brings the best out of everyone",
                  nextButton: nextButton(ab),
                  index: 0,
                  pageController: _pageController,
                ),
                SinglePage(
                  imagePath: "assets/images/onboard2.png",
                  title: "Improve Efficiency",
                  subtitle:
                      "Interact effectively with your students and manage them through dynamic classrooms accessible 24*7",
                  nextButton: nextButton(ab),
                  index: 0,
                  pageController: _pageController,
                ),
                SinglePage(
                  imagePath: "assets/images/onboard3.png",
                  title: "Seamless Experience",
                  subtitle: "Check your due assignments, upcoming exams and "
                      "allotted grade all from the comfort of your home",
                  nextButton: nextButton(ab),
                  index: 1,
                  pageController: _pageController,
                ),
                SinglePage(
                  imagePath: "assets/images/onboard4.png",
                  title: "Highly Secure",
                  subtitle:
                      "Your are in control of your data. Your data and work "
                      "are protected by industry grade end-to-end encryption",
                  nextButton: nextButton(ab),
                  index: 2,
                  pageController: _pageController,
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  if (currentIndex != 0)
                    IconButton(
                      onPressed: () {
                        previousFunction();
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  else
                    const SizedBox(
                      width: 50,
                    ),
                  const Spacer(),
                  indicator,
                  const Spacer(),
                  const SizedBox(
                    width: 65,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nextButton(AuthenticationBloc ab) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: CircularProgressIndicator(
            strokeWidth: 4,
            value: (currentIndex + 1) / 4,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
            backgroundColor: Colors.transparent,
          ),
        ),
        Card(
          color: const Color(0xffeef5db),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            onPressed: () {
              nextPage(ab);
            },
            icon: Icon(
                currentIndex == 3 ? Icons.done : Icons.arrow_forward_rounded,
                color: Colors.black),
          ),
        ),
      ],
    );
  }

  void nextPage(AuthenticationBloc ab) {
    if (currentIndex < 3) {
      nextFunction();
    }
  }

  Widget getImage(Size size) {
    return const Center(
      child: Icon(
        FontAwesomeIcons.shieldHalved,
        size: 140,
        color: Colors.white,
      ),
    );
  }
}
