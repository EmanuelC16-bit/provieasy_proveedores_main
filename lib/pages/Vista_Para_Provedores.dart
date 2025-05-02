import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProviderHomePage(),
    );
  }
}

class ProviderHomePage extends StatelessWidget {
  Widget sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    child: Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  Widget requestCard(String name, String rating, String distance, String pickup, String dropoff, {bool showActions = true}) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 24, backgroundImage: AssetImage('assets/profile_placeholder.png')),
              SizedBox(width: 12),
              Expanded(child: Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
              Text(rating, style: TextStyle(color: Colors.grey[700]))
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.navigation, size: 16),
              SizedBox(width: 4),
              Text(distance),
            ],
          ),
          SizedBox(height: 4),
          Text("📍 $pickup"),
          Text("📍 $dropoff"),
          if (showActions)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () {}, child: Text("Decline")),
                ElevatedButton(onPressed: () {}, child: Text("Accept")),
              ],
            )
        ],
      ),
    ),
  );

  Widget ongoingServiceCard(String name, String rating, String address) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage('assets/profile_placeholder.png')),
      title: Text(name),
      subtitle: Text(rating),
      trailing: ElevatedButton(
        onPressed: () {},
        child: Text("Go to Pickup"),
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Requests"),
        backgroundColor: Colors.blue[700],
      ),
      body: ListView(
        children: [
          sectionTitle("Pending Requests"),
          requestCard("Emily Clark", "⭐ 4.3", "4.2 km", "54 rue du Gue Jacquet", "66, av rue l'Alouette"),
          requestCard("Kyle Hall", "⭐ 4.3", "1.0 km", "33 avenue Jean Jaurès", "47 rue de l'Alouette"),
          sectionTitle("Ongoing Services"),
          ongoingServiceCard("Vitt Xtra", "⭐ 4.3", "25 place Paul Doumer"),
          sectionTitle("Rejected Services"),
          requestCard("Melissa Brunt", "⭐ 4.3", "", "", "", showActions: false),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Earnings"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}
