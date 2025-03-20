import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SocialMedia {
  final String id;
  final String name;
  final String description;
  final String url;
  final String type;

  SocialMedia({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.type,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      url: json['url'],
      type: json['type'],
    );
  }

  static List<SocialMedia> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SocialMedia.fromJson(json)).toList();
  }
}

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  List<SocialMedia> _items = [];
  List<SocialMedia> _filteredItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://202.21.32.27:3000/about-us/drivers'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> allItems = data['data'];
      List<SocialMedia> filteredItems = SocialMedia.fromJsonList(
        allItems
            .where((item) => ['6', '7', '8', '9', '10'].contains(item['id']))
            .toList(),
      );
      setState(() {
        _items = filteredItems;
        _filteredItems = _items;
        _isLoading = false;
      });
    }
  }

  void filterSearch(String query) {
    setState(() {
      _filteredItems =
          _items.where((item) {
            return item.name.toLowerCase().contains(query.toLowerCase());
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              alignment: Alignment.center,
              child: Text(
                'About Us',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                onChanged: filterSearch,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child:
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.separated(
                        itemCount: _filteredItems.length,
                        separatorBuilder:
                            (context, index) => SizedBox(height: 1),
                        itemBuilder: (context, index) {
                          var item = _filteredItems[index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 209, 208, 208)
                              ),
                              borderRadius: BorderRadius.circular(1.0),
                              color: Colors.white,
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(12),
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                child: Text(
                                  item.name[0],
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              title: Text(
                                item.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(item.description),
                              trailing: Icon(Icons.arrow_forward_ios, size: 16),
                              //onTap: () => print('Navigating to ${item.url}'),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
