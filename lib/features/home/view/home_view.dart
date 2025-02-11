import 'package:devconnect/constants/ui_constants.dart';
import 'package:devconnect/features/post/views/create_post_view.dart';
import 'package:devconnect/features/post/widgets/post_list.dart';
import 'package:devconnect/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final appbar = UiConstants.appBar();

  int _page = 0;

  onPageChanged(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: IndexedStack(
        index: _page,
        children: [
          Center(
            child: PostList(),
          ),
          Center(
            child: Text('Search'),
          ),
          Center(
            child: Text('Notifications'),
          ),
          Center(
            child: Text('Messages'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CreatePostView.route());
        },
        shape: CircleBorder(),
        child: Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: onPageChanged,
        items: [
          BottomNavigationBarItem(
            icon: _page == 0
                ? Icon(
                    Icons.home,
                    color: Pallete.whiteColor,
                  )
                : Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _page == 1
                ? Icon(
                    Icons.search,
                    color: Pallete.whiteColor,
                  )
                : Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: _page == 2
                ? Icon(
                    Icons.notifications,
                    color: Pallete.whiteColor,
                  )
                : Icon(Icons.notifications_none),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: _page == 3
                ? Icon(
                    Icons.mail,
                    color: Pallete.whiteColor,
                  )
                : Icon(
                    Icons.mail_outline,
                  ),
            label: 'Messages',
          ),
        ],
      ),
    );
  }
}
