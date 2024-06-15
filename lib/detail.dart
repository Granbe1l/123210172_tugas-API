import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final int Id;

  DetailPage({required this.Id});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic> CardDetails = {};

  @override
  void initState() {
    super.initState();
    fetchCardDetails();
  }

  Future<void> fetchCardDetails() async {
    final response = await http.get(Uri.parse('https://db.ygoprodeck.com/api/v7/cardinfo.php'));
    if (response.statusCode == 200) {
      setState(() {
        CardDetails = json.decode(response.body)['data'];
      });
    } else {
      print('Failed to load Card details');
    }
  }

  Widget buildTextSection(String label, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 16),
          children: [
            TextSpan(text: "$label: ", style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: text),
          ],
        ),
      ),
    );
  }

  Widget buildLinkSection(String label, List<dynamic> items) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Column(
            children: items.map<Widget>((item) => InkWell(
              onTap: () => _launchURL(item['url']),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Text(item['name'], style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 16)),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (!await canLaunchUrl(Uri.parse(url))) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not launch $url'),
      ));
    } else {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text(CardDetails.isNotEmpty ? CardDetails['title'] : 'Loading...'),
      ),
      body: CardDetails.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Container(
          color: Color(0xFFFFF7F5),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(CardDetails['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24), textAlign: TextAlign.center),
              SizedBox(height: 20),
              Image.network(CardDetails['images']['jpg']['large_image_url'], fit: BoxFit.contain, height: 200),
              SizedBox(height: 20),
              buildTextSection("Name", CardDetails['name']),
              buildTextSection("Type", CardDetails['type']),
              buildTextSection("Desc", CardDetails['desc']['string']),
              buildTextSection("Race", CardDetails['race'].toString()),
              buildTextSection("Archetype", CardDetails['archetype'].toString()),
              buildTextSection("Set Rarity", CardDetails['set_rarity'].toString()),
              if (CardDetails['name'] != null)
                buildLinkSection("Name", CardDetails['name']),
              if (CardDetails['type'] != null)
                buildLinkSection("Type", CardDetails['type']),
              if (CardDetails['desc'] != null)
                buildLinkSection("Desc", CardDetails['desc']),
              if (CardDetails['race'] != null)
                buildLinkSection("Race", CardDetails['race']),
              if (CardDetails['archetype'] != null)
                buildLinkSection("Archetype", CardDetails['archetype']),
              if (CardDetails['Set Rarity'] != null)
                buildLinkSection("Set Rarity", CardDetails['card_set'][0]['set_rarity']),
              if (CardDetails['url'] != null)
                Container(
                  color: Color(0xFF222831), // Ubah warna background
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 20),
                      Text(CardDetails['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24), textAlign: TextAlign.center),
                      SizedBox(height: 20),
                      Image.network(CardDetails['images']['jpg']['large_image_url'], fit: BoxFit.contain, height: 200),
                      SizedBox(height: 20),
                      buildTextSection("Name", CardDetails['name']),
                      buildTextSection("Type", CardDetails['type']),
                      buildTextSection("Desc", CardDetails['desc']['string']),
                      buildTextSection("Race", CardDetails['race'].toString()),
                      buildTextSection("Archetype", CardDetails['archetype'].toString()),
                      buildTextSection("Set Rarity", CardDetails['set_rarity'].toString()),
                      if (CardDetails['name'] != null)
                        buildLinkSection("Name", CardDetails['name']),
                      if (CardDetails['type'] != null)
                        buildLinkSection("Type", CardDetails['type']),
                      if (CardDetails['desc'] != null)
                        buildLinkSection("Desc", CardDetails['desc']),
                      if (CardDetails['race'] != null)
                        buildLinkSection("Race", CardDetails['race']),
                      if (CardDetails['archetype'] != null)
                        buildLinkSection("Archetype", CardDetails['archetype']),
                      if (CardDetails['Set Rarity'] != null)
                        buildLinkSection("Set Rarity", CardDetails['card_set'][0]['set_rarity']),
                      if (CardDetails['url'] != null)
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              child: Text('More Info', style: TextStyle(color: Colors.white, fontSize: 18)),
                            ),
                            onPressed: () => _launchURL(CardDetails['url']),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent[100],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                          ),
                        )
                    ],
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }
}
