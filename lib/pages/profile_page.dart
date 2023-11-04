import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tierlistapp/components/my_backbotton.dart';
import 'package:tierlistapp/components/my_drawer.dart';
import 'package:tierlistapp/models/index.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:tierlistapp/components/my_drawer.dart';
import 'package:tierlistapp/models/index.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  ProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('P R O F I L E'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: MyDrawer(user: user,),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(25),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(75), // กำหนดขนาดรูปภาพเป็น 150x150
                  child: user.imageUrl != null
                      ? Image.memory(
                          base64Decode(user.imageUrl!),
                          width: 300,
                          height: 300,
                        )
                      : Icon(
                          Icons.person,
                          size: 150, // กำหนดขนาดไอคอน 150x150
                        ), // Display the default icon if user.image is null
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                '${user.username}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${user.email}',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(
                height: 50,
              ),
              MyBackButton(),
            ],
          ),
        ),
      ),
    );
  }
}
