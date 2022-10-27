import 'package:classroom/blocs/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AppNavigationController extends StatefulWidget {
  const AppNavigationController({Key? key}) : super(key: key);

  @override
  State<AppNavigationController> createState() =>
      _AppNavigationControllerState();
}

class _AppNavigationControllerState extends State<AppNavigationController> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    NavigationBloc nb = Provider.of<NavigationBloc>(context);

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: showFab,
        child: FloatingActionButton(
          onPressed: () {
            nb.changeNavIndex(2);
          },
          backgroundColor: Colors.deepPurpleAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.white, width: 3),
          ),
          elevation: 4,
          child: const Icon(
            Icons.savings,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.white,
        elevation: 18,
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: nb.bottomNavIndex,
          backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          selectedIconTheme: const IconThemeData(
            color: Colors.deepPurpleAccent,
          ),
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "PublicSans",
            fontSize: nb.bottomNavIndex == 3 ? 12 : 14,
            color: Colors.amberAccent,
          ),
          selectedItemColor: Colors.amberAccent,
          unselectedIconTheme: IconThemeData(
            color: Colors.deepPurpleAccent.withOpacity(0.6),
          ),
          onTap: (index) {
            nb.changeNavIndex(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: getBottomNavBarIcon(FontAwesomeIcons.solidCircleUser),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: getBottomNavBarIcon(FontAwesomeIcons.clipboardList),
              label: "Activity",
            ),
            const BottomNavigationBarItem(
              icon: SizedBox(
                height: 30,
              ),
              label: "Get Cash",
            ),
            BottomNavigationBarItem(
              icon: getBottomNavBarIcon(FontAwesomeIcons.clockRotateLeft),
              label: "Payments",
            ),
            BottomNavigationBarItem(
              icon: getBottomNavBarIcon(FontAwesomeIcons.coins),
              label: "Repay",
            ),
          ],
        ),
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
