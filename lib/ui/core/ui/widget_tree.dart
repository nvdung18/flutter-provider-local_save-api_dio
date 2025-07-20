import 'package:flutter/material.dart';
import 'package:flutter_provider_local_save/utils/app_state.dart';
import 'package:flutter_provider_local_save/utils/constant.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    // Responsive values
    final double appBarHeight = isTablet ? 90 : 72;
    final double iconSize = isTablet ? 28 : 20;
    final double iconContainer = isTablet ? 56 : 40;
    final double navBarHeight = isTablet ? 90 : 70;
    final double navBarMargin = isTablet ? 32 : 16;
    final double navBarPaddingH = isTablet ? 40 : 24;
    final double navBarPaddingV = isTablet ? 16 : 8;
    final double navBarRadius = isTablet ? 40 : 30;
    final double titleFontSize = isTablet ? 28 : 20;

    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(appBarHeight),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double iconContainer = constraints.maxHeight * 0.6;
                final double iconSize = iconContainer * 0.5;
                final double titleFontSize = constraints.maxHeight * 0.32;

                return AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  toolbarHeight: constraints.maxHeight,
                  actionsPadding: EdgeInsets.only(
                    right: constraints.maxWidth * 0.03,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'News',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'App',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  centerTitle: true,
                  actions: [
                    Container(
                      width: iconContainer,
                      height: iconContainer,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(iconContainer / 2),
                      ),
                      child: Icon(
                        Icons.mic_none,
                        color: Colors.black,
                        size: iconSize,
                      ),
                    ),
                    SizedBox(width: constraints.maxWidth * 0.01),
                  ],
                  leading: Padding(
                    padding: EdgeInsets.only(left: constraints.maxWidth * 0.01),
                    child: IconButton(
                      onPressed: () {
                        // Handle menu button press
                      },
                      padding: EdgeInsets.zero,
                      icon: Container(
                        width: iconContainer,
                        height: iconContainer,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(
                            iconContainer / 2,
                          ),
                        ),
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: iconSize,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          body: IndexedStack(
            index: selectedPage,
            children: KNavbar.pageNavBar()
                .map((e) => e['page'] as Widget)
                .toList(),
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.all(navBarMargin),
            padding: EdgeInsets.symmetric(
              horizontal: navBarPaddingH,
              vertical: navBarPaddingV,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(navBarRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: NavBarWidget(navBarHeight: navBarHeight),
          ),
        );
      },
    );
  }
}

class NavBarWidget extends StatelessWidget {
  final double navBarHeight;
  const NavBarWidget({super.key, required this.navBarHeight});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          height: navBarHeight,
          backgroundColor: Colors.white,
          indicatorColor: Colors.purple.withOpacity(0.08),
          surfaceTintColor: Colors.white,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          elevation: 0,
          destinations: [
            for (var item in KNavbar.pageNavBar())
              NavigationDestination(
                icon: Icon(item['icon']),
                label: '',
                selectedIcon: Icon(item['selectedIcon']),
              ),
          ],
          onDestinationSelected: (int index) {
            selectedPageNotifier.value = index;
          },
          selectedIndex: selectedPage, // Set the initial selected index
        );
      },
    );
  }
}
