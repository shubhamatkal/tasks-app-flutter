import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../dashboard/dashboard_screen.dart';
import '../profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          DashboardScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        selectedIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  const _BottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidth = constraints.maxWidth / 2;

        return Container(
          height: 80,
          color: kSurfaceColor,
          child: Stack(
            children: [
              // Sliding indicator line at the bottom
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: 0,
                left: selectedIndex * tabWidth,
                child: Container(
                  width: tabWidth,
                  height: 2.5,
                  color: kPrimaryColor,
                ),
              ),
              // Tab items
              Row(
                children: [
                  _TabItem(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    isSelected: selectedIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _TabItem(
                    icon: Icons.person_outline,
                    label: 'Profile',
                    isSelected: selectedIndex == 1,
                    onTap: () => onTap(1),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? _filledIcon : icon,
                key: ValueKey(isSelected),
                color: isSelected ? kPrimaryColor : kTextMuted,
                size: 26,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? kPrimaryColor : kTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _filledIcon => switch (icon) {
        Icons.home_outlined => Icons.home,
        Icons.person_outline => Icons.person,
        _ => icon,
      };
}
