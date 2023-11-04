import 'package:flutter/material.dart';
import 'package:tierlistapp/auth/login_or_register.dart';
import 'package:tierlistapp/models/index.dart';
import 'package:tierlistapp/pages/home_page.dart';
import 'package:tierlistapp/pages/login_page.dart';
import 'package:tierlistapp/pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  final User user;

  MyDrawer({Key? key, required this.user}) : super(key: key);

  void logout() {
    // ทำรายการที่เกี่ยวข้องกับการออกจากระบบ
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Icon(
                  Icons.favorite,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: Text("H O M E"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomepPage(
                       user,
                    ),
                  ));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: Text("P R O F I L E"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      user: user,
                    ),
                  ));
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: Text("L O G O U T"),
              onTap: () {
               Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LoginOrRegister(),
                  )); // ปรับแก้ URL ตามการเรียกใช้งานใน routes
              },
            ),
          ),
        ],
      ),
    );
  }
}
