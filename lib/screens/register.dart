import 'package:flutter/material.dart';
import 'package:notes_vault/services/auth.dart';
import 'package:notes_vault/shared/constant.dart';
import 'package:notes_vault/shared/loading.dart';
class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading=false;

  String email='';
  String password='';
  String error='';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text('Register to SecuraServ'),
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.0,vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'E-mail'),
                validator: (val) => val.isEmpty? 'Enter E-mail':null,
                onChanged: (val) {
                  setState(() {
                    email=val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                validator: (val) => val.length<6? 'Enter a password 6 + characters long':null,
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password=val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  //print(email);
                  //print(password);
                  if(_formKey.currentState.validate())
                    {
                      setState(() {
                        loading=true;
                      });
                      dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                      if(result==null)
                        {
                          setState(() {
                            error='Please supply valid email';
                            loading=false;
                          });
                        }
                      /*print(email);
                      print(password);*/
                    }
                },
              ),
              SizedBox(height: 12.0,),
              Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.0
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
