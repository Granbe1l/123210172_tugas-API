import 'package:flutter/material.dart';
import 'detail.dart';
import 'profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List recommendations = [];
  int currentPage = 1;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    fetchCardRecommendations(currentPage);
  }

  Future<void> fetchCardRecommendations(int page) async {
    final response = await http.get(Uri.parse('https://db.ygoprodeck.com/api/v7/cardinfo.php'));
    if (response.statusCode == 200) {
      var newData = json.decode(response.body)['data'];
      setState(() {
        if (newData.isEmpty) {
          hasMoreData = false;
        } else {
          recommendations = newData;
          hasMoreData = true;
        }
      });
    }
  }

  void _nextPage() {
    if (hasMoreData) {
      setState(() {
        currentPage++;
        fetchCardRecommendations(currentPage);
      });
    }
  }

  void _previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        fetchCardRecommendations(currentPage);
      });
    }
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: currentPage > 1 ? _previousPage : null,
          color: currentPage > 1 ? Colors.pinkAccent[100] : Colors.grey,
        ),
        Text('Page $currentPage', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: hasMoreData ? _nextPage : null,
          color: hasMoreData ? Colors.pinkAccent[100] : Colors.grey,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text('Yu-Gi-Oh Card List', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage())),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF222831),
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Expanded(
              child: recommendations.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final item = recommendations[index];
                  return Card(
                    color: Colors.pink[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              Id: item['id'],
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                              child: Image.network(
                                item['card_images'][0]['image_url'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              item['name'],
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                            child: Text(
                              'Type: ${item['type']}',
                              style: TextStyle(fontSize: 12, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildPaginationControls(),
          ],
        ),
      ),
    );
  }
}
