import 'package:classroom/blocs/classroom_bloc.dart';
import 'package:classroom/blocs/navigation_bloc.dart';
import 'package:classroom/blocs/user_bloc.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AppNavigationController extends StatefulWidget {
  const AppNavigationController({Key? key}) : super(key: key);

  @override
  State<AppNavigationController> createState() =>
      _AppNavigationControllerState();
}

class _AppNavigationControllerState extends State<AppNavigationController>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    NavigationBloc nb = Provider.of<NavigationBloc>(context);
    ClassroomBloc cb = Provider.of<ClassroomBloc>(context);
    UserBloc ub = Provider.of<UserBloc>(context);

    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
        title: const Text(
          "Classroom",
          style: TextStyle(
            fontFamily: "PublicSans",
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.deepPurpleAccent,
        ),
      ),
      // drawer: const AppDrawer(),
      floatingActionButton: !showFab
          ? const SizedBox()
          : FloatingActionBubble(
              items: <Bubble>[
                Bubble(
                  title: "Join Class",
                  iconColor: Colors.blue,
                  bubbleColor: Colors.white,
                  icon: Icons.join_inner,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontFamily: "PublicSans",
                    fontWeight: FontWeight.bold,
                  ),
                  onPress: () async {
                    await cb.joinClass(context, "EnterClassroomID", ub.uid);
                    _animationController.reverse();
                  },
                ),
                Bubble(
                  title: "Create Class",
                  iconColor: Colors.blue,
                  bubbleColor: Colors.white,
                  icon: Icons.create,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontFamily: "PublicSans",
                    fontWeight: FontWeight.bold,
                  ),
                  onPress: () async {
                    await cb.createClass(context, "ClassName", ub.uid, "ClassColor", "Description");
                    _animationController.reverse();
                  },
                ),
              ],
              animation: _animation,
              onPress: () => _animationController.isCompleted
                  ? _animationController.reverse()
                  : _animationController.forward(),
              iconColor: Colors.blue,
              iconData: FontAwesomeIcons.circlePlus,
              backGroundColor: Colors.white,
            ),
      body: SizedBox(
        width: size.width,
        child: getBody(nb.bottomNavIndex),
      ),
    );
  }

  Widget getBody(int index) {
    switch (index) {
      case 0:
        return Container();
      // case 1:
      //   return const LoanActivityPage();
      // case 2:
      //   return const HomePage();
      // case 3:
      //   return const PaymentActivityPage();
      // case 4:
      //   return const DuePaymentsPage();
      default:
        return Container();
    }
  }

  Widget getBottomNavBarIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        icon,
      ),
    );
  }
}
