import 'package:classroom/blocs/auth_bloc.dart';
import 'package:classroom/blocs/user_bloc.dart';
import 'package:classroom/utils/snackbar.dart';
import 'package:flutter/material.dart';

///Unified class for single page of onboarding PageView
class SinglePage extends StatelessWidget {
  final String imagePath, title, subtitle;
  final Widget nextButton;
  final PageController pageController;
  final AuthenticationBloc ab;
  final UserBloc ub;

  const SinglePage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.nextButton,
    required this.pageController,
    required this.ab,
    required this.ub,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: size.width,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        getTextContent(size),
        const SizedBox(
          height: 80,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: 65,
            width: size.width / 1.4,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(15),
              ).copyWith(
                elevation: MaterialStateProperty.resolveWith<double>(
                  (Set<MaterialState> states) {
                    // if the button is pressed the elevation is 10.0, if not
                    // it is 5.0
                    if (states.contains(MaterialState.pressed)) {
                      return 5.0;
                    }
                    return 10.0;
                  },
                ),
              ),
              onPressed: () {
                ///TODO
                if (ab.isLoading) {
                  showSnackBar(context,"Please wait. Login in progress");
                  return;
                }
                ab.signInWithGoogle(context, ub);
              },
              icon:
                  // ab.isGoogleSignInOngoing
                  //     ? Stack(
                  //         alignment: Alignment.center,
                  //         children: [
                  //           Image.asset(
                  //             "assets/images/google_logo.png",
                  //             width: 30,
                  //             height: 30,
                  //           ),
                  //           const Center(
                  //             child: CircularProgressIndicator(
                  //               color: Color(0xff87ceeb),
                  //             ),
                  //           ),
                  //         ],
                  //       )
                  //     :
                  Image.asset(
                "assets/images/google_logo.png",
                width: 40,
                height: 40,
              ),
              label: const Text(
                "Continue with Google",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getTextContent(Size size) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: size.width,
            child: Row(
              children: [
                SizedBox(
                  width: size.width * 0.7,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 27,
                      letterSpacing: 1.3,
                      fontFamily: "PublicSans",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                nextButton,
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: size.width / 1.4,
            child: Text(
              subtitle,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: "PublicSans",
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
