import 'package:devconnect/common/common.dart';
import 'package:devconnect/features/auth/controller/auth_controller.dart';
import 'package:devconnect/features/user_profile/view/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    if(currentUser == null) {
      Loader();
    }
    return SafeArea(
      child: Drawer(
        
        child: Column(
          
          
          children: [
            SizedBox(
              height: 50,
            ),  
            ListTile(
                leading: Icon(Icons.person, size: 30),
                title: Text(
                  'Profile',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(context, UserProfileView.route(currentUser!));
                }),
            ListTile(
                leading: Icon(Icons.logout, size: 30),
                title: Text(
                  'Logout',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  ref.read(authControllerProvider.notifier).logout(context, ref);
                })
          ],
        ),
      ),
    );
  }
}
