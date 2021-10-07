import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_vault/screens/addnote.dart';
import 'package:notes_vault/services/auth.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_vault/shared/loading.dart';
import 'package:notes_vault/screens/viewnote.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  static FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference ref;
  void someFunction() async{
    try{
      final User user = await auth.currentUser;
      final dynamic uid = user.uid;
      ref = await FirebaseFirestore.instance.collection('users')
          .doc(uid)
          .collection('notes');
    }
    catch(e)
    {
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    someFunction();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('SecuroServ'),
        backgroundColor: Colors.purple[400],
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();
            },
            label: Text('Log Out'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white70,),
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddNote())
          ).then((value) {
            setState(() {});
          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<QuerySnapshot>(
          future: ref.get(),
          builder: (context,snapshot) {
            if(snapshot.hasData)
              {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context,index) {
                    Map data = snapshot.data.docs[index].data();
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewNote(data: data,ref: snapshot.data.docs[index].reference,))).then((value) {setState(() {

                        });});
                      },
                      child: Card(
                        color: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${data['title']}',
                                style: TextStyle(
                                    fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.black
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    }
                );
              }
            else{
              return Loading();
            }
          },
        ),
      ),
    );
  }
}
