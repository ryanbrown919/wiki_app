import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: 'Know More',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String articleTitle = 'Welcome to Know More';
  String articleBody = 'Test';
  String articleThumbnail = '';
  String articleType = '';
  String? articleCoordinates = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  String findType(var data){

    if (data['coordinates'] != null) {
      return 'Place';
    }
    else {
      return 'IDK yet';
    }

  }

  Future<void> fetchData() async {

    var response = await http.get(Uri.parse('https://en.wikipedia.org/api/rest_v1/page/random/summary'));
    // Assuming the response is JSON and has a title field
    if (response.statusCode == 200) {
      
      var data = json.decode(response.body);

      setState(() {

        articleTitle = data['title']; // Update this with actual article title from JSON
        articleBody = data['extract'];
        articleThumbnail = data['originalimage']['source'];
        articleCoordinates = data['coordinates'];
        articleType = findType(data);

      });
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Know More',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                
              ),
            ),
            ListTile(title: Text(articleType)),
            ListTile(title: Text('Option 2')),
          ],
        ),
      ),
      // body: ListView(
      //   children: [
      //     Column(
      //     children: [
      //     Text(articleTitle,
      //     style: TextStyle(fontSize: 30.0)),
      //     Text(articleBody,
      //     style: TextStyle(fontSize: 15)),]
      //   )]
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),  // Add padding around the entire content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,  // Aligns content to the start of the column
            children: [
              Text(
                articleType,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$articleCoordinates',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                articleTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),  // Adds space between title and text block
              Text(
                articleBody,                
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16.0),  // Adds space between text block and images
              Image.network(articleThumbnail),
              // Add more widgets as needed
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (fetchData), // Call fetchData when the button is pressed
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }
}