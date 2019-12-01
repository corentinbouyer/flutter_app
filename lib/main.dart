import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Project Flutter';

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

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final ville=TextEditingController();
  final activite=TextEditingController();


  Future<String> fetchPost(String ville, String activite) async {
   
    final baseUrl = "https://api.foursquare.com/v2/venues/search";
    final clientID = "3U0G3142QBMKWZDZCVUEVBJDTAQLV0233ZQBFPYJSQPPSY5W";
    final clientSecret="MDFYETL2NW0S3ZRHKQ5RDTVBTLPOYN5CPSX4JZ4DTI5KQTUK";
    final response = await http.get(
        baseUrl + "?client_id=" + clientID + "&client_secret=" + clientSecret +
            "&v=20181231&near=" + ville + "&query=" +
            activite);


      print(response.body);



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

          new Scaffold(
            body: new Center(
              child: new RaisedButton(
                  child: new Text("Valider"),

              ),
            ),
          )

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
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}