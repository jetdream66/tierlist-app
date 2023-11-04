import 'package:flutter/material.dart';
import 'package:tierlistapp/components/my_button.dart';
import 'package:tierlistapp/components/list_tierlists.dart';
import 'package:tierlistapp/components/my_drawer.dart';
import 'package:tierlistapp/pages/categories_page.dart';
import 'package:tierlistapp/pages/profile_page.dart';
import 'package:tierlistapp/models/index.dart';

class HomepPage extends StatefulWidget {
  final User user;

  HomepPage(this.user);

  @override
  _HomepPageState createState() => _HomepPageState(user);
}

class _HomepPageState extends State<HomepPage> {
  final User user;
  _HomepPageState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      
      appBar: AppBar(
        
        title: Text("H O M E"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: <Widget>[
          
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(user: user),
              ));
            },
            
          ),
          
        ],
        
      ),
      drawer: MyDrawer(user: user,),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CategoriesPage(user: user),
          ));
        },
        child: Icon(Icons.add), // ไอคอน '+'
        backgroundColor: const Color.fromARGB(255, 241, 241, 241), // สีพื้นหลังของปุ่ม
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Remove the MyButton widget
              SizedBox(width: 8),
              // Wrap ListTierLists with Expanded
              Expanded(
                child: ListTierLists(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
