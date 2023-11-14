import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goconcert/pages/bookmark_page.dart';
import 'package:goconcert/pages/dashboard.dart';
import 'package:goconcert/pages/my_tickets.dart';
import 'package:goconcert/pages/profile_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentPage;
  final Function(int) onPageChanged;

  BottomNavBar({
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBottomNavBarIcon(
            iconData: FontAwesomeIcons.home,
            isSelected: currentPage == 0,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardWidget()),
              );
              onPageChanged(0);
            },
          ),
          _buildBottomNavBarIcon(
            iconData: FontAwesomeIcons.bookmark,
            isSelected: currentPage == 1,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkPage()),
              );
              onPageChanged(1);
            },
          ),
          _buildBottomNavBarIcon(
            iconData: FontAwesomeIcons.ticketAlt,
            isSelected: currentPage == 2,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyTicketsPage()),
              );
              onPageChanged(2);
            },
          ),
          _buildBottomNavBarIcon(
            iconData: FontAwesomeIcons.user,
            isSelected: currentPage == 3,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
              onPageChanged(3);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBarIcon({
    required IconData iconData,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 40.0,
          width: 40.0,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0E0837) : Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Icon(
            iconData,
            color: isSelected ? Colors.white : const Color(0xFF9B9B9B),
            size: 20.0,
          ),
        ),
      ),
    );
  }
}
