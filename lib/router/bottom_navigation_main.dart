import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/feature/presentation/flight_list/view/flight_list.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, keepPage: true);
  }

  final List<Widget> _screens = [
    const FlightListScreen(isMyFlight: true),
    const FlightListScreen(isMyFlight: false),
  ];

  final List<SalomonBottomBarItem> selectedItem = [
    SalomonBottomBarItem(
      icon: Icon(Icons.flight, size: 24.w),
      title: Text("Lịch bay của tôi",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
      selectedColor: Colors.blueAccent,
    ),
    SalomonBottomBarItem(
      icon: Icon(Icons.flight_takeoff_rounded, size: 24.w),
      title: Text("Toàn bộ lịch bay",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
      selectedColor: const Color.fromARGB(255, 5, 9, 195),
    ),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          margin: EdgeInsets.only(left: 24.w, right: 24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SalomonBottomBar(
            currentIndex: _selectedIndex,
            onTap: _onTabTapped,
            unselectedItemColor: Colors.grey,
            itemPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 32.w),
            items: selectedItem,
          ),
        ),
      ),
    );
  }
}