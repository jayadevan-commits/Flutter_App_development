import 'package:flutter/material.dart';
import 'package:my_form_app/screens/Home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'form_details_list.dart';
import 'dashboard_page.dart';
import 'profile_page.dart';

class HomePageBottom extends StatefulWidget {
  const HomePageBottom({super.key});

  @override
  State<HomePageBottom> createState() => _HomePageBottomState();
}

class _HomePageBottomState extends State<HomePageBottom> {
String userEmail ='';
int _currentIndex =0;

// // Bottom navigation pages
// final List<Widget> _pages = const[
//   Dashboard(),
//   formListScreen(),
//   ProfilePage(),
// ];
  @override
 void initState() {
  super.initState();
  loadUserEmail();
 }

 // get logged_in Email from local storage

 Future<void> loadUserEmail() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    userEmail = prefs.getString('loggedInEmail') ?? 'No Email';
  });
 }

// Pages controlled by Bottom Navigation
  final List<Widget> _pages = const [
    HomePage(),
    Dashboard(),
    formListScreen(),
    ProfilePage(),
    // Center(
    //   child: Text(
    //     'Profile / Home Features Coming Soon',
    //     style: TextStyle(fontSize: 18),
    //   ),
    // ),
  ];

 @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Employee Management'),
        backgroundColor: Colors.teal,
      ),

      // Drawer ( shared)
      drawer: Drawer(
        child: Column(
          children: [

            // Profile header
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
              color: Colors.teal,
            ),
            accountName: const Text(
              'Welcome',
            style: TextStyle(
              fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(userEmail),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.teal,
                ),
            ),
            ),
           // Dashboard Menu
           ListTile(
            leading: const Icon(Icons.dashboard),
            title:const Text ('Dashboard'),
            onTap: () {
              setState(() {
                _currentIndex=1;
              });
               Navigator.pop(context); // just close the drawer
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_)=> const Dashboard() ),
              // );
            },
           ),
           const Divider(),
           // Employee Menu
           ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Employee'),
            onTap: () {
              // Navigator.push(
              //   context, 
              //   MaterialPageRoute(
              //     builder: (_)=> const formListScreen(),
              //   ),
              // );
              setState(() {
                _currentIndex =2;
              });
              Navigator.pop(context);
            },
           ),

           const Divider(),
           // 🚪 LOGOUT 
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            
          ],
        ),
      ),

     // Page switching
     body: IndexedStack(
      index: _currentIndex,
      children: _pages,
     ),

     //Navigation Bar
     bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor:Colors.teal,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        // If Home tapped -> go to dashboard
        
        //  setState(() {
        // if (index ==3) {
         setState(() {
          _currentIndex = index;
        });
        // _currentIndex=0;
      // } else {
      //   _currentIndex = index;
      // }
      //});
  },
      
      items: const [
        BottomNavigationBarItem(
            icon:Icon(Icons.home),
            label:'Home',
            ),

        BottomNavigationBarItem(
          icon:Icon(Icons.dashboard),
          label: 'Dashboard'
           ),
        
        BottomNavigationBarItem(
          icon:Icon(Icons.list),
          label: 'Employees',
          ),

          BottomNavigationBarItem(
            icon:Icon(Icons.person),
            label:'Profile',
            ),
             ],
     ),
    );
  }
  }