import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Project Flutter Corentin Bouyer';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}
Future<Post> fetchPost() async {
  final baseUrl = "https://api.foursquare.com/v2/venues/search";
  final clientID = "3U0G3142QBMKWZDZCVUEVBJDTAQLV0233ZQBFPYJSQPPSY5W";
  final clientSecret="MDFYETL2NW0S3ZRHKQ5RDTVBTLPOYN5CPSX4JZ4DTI5KQTUK";
  final response = await http.get(
      baseUrl + "?client_id=" + clientID + "&client_secret=" + clientSecret +
          "&v=20181231&near=nantes&query=bar");

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final ville=TextEditingController();
  final activite=TextEditingController();
  Future<Post> post;

  @override
  void initState() {
    super.initState();
    post = fetchPost();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new TextFormField(
              controller: ville,
              decoration: InputDecoration(
                  labelText: 'Entrer la ville souhaité')
          ),
          new TextFormField(
              controller: activite ,
              decoration: InputDecoration(
                  labelText: 'Entrer l activité souhaité')
          ),
          new FutureBuilder<Post>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.venues);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
          new Padding(
            padding: const EdgeInsets.symmetric(vertical : 16.0),
            child: RaisedButton(
              onPressed: () {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text(activite.text),

                    );
                  },
                );
              },

              child: Text('Rechercher'),

            ),
          ),


        ],
      ),

    );
  }
}


class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class Post {
  final String meta;
  final String venues;

  Post({ this.meta, this.venues});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(

      meta: json["meta"],
      venues: json["response"],
    );
  }
}
