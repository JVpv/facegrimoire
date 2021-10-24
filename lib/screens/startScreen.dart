import 'package:facegrimoire/components/actionsButton.dart';
import 'package:facegrimoire/components/postCreationForm.dart';
import 'package:facegrimoire/core/models/postFormData.dart';
import 'package:facegrimoire/core/service/auth/authService.dart';
import 'package:flutter/material.dart';
import 'package:facegrimoire/extensions/color.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool composingMessage = false;

  _initToken() async {
    print("Init");
  }

  @override
  void initState() {
    super.initState();
    _initToken();
  }

  _onSubmitPost(PostFormData data) {
    print("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text(
          composingMessage ? "New post" : "Welcome",
          style: TextStyle(fontSize: 24),
        ), //_currentIndex==0 ? "Notícias" : _currentIndex==1 ? "Mensagens dos sócios" : "Aniversariantes do dia", style: TextStyle(fontSize: 24,),),
        backgroundColor: primary,
        centerTitle: true,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 3),
            child: Stack(
              children: [
                IconButton(
                    onPressed: () {
                      print("Notifications");
                    },
                    icon: Icon(Icons.notifications)),
                Positioned(
                  top: 5,
                  right: 5,
                  child: CircleAvatar(
                    maxRadius: 10,
                    backgroundColor: Colors.red.shade800,
                    child: Text(
                        "0", //"${Provider.of<ChatNotificationService>(context).itemsCount < 10 ? Provider.of<ChatNotificationService>(context).itemsCount : '9+'}",
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {},
          ),
          ActionsButton(),
        ],
      ),
      body: SafeArea(
        child: composingMessage
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: PostCreationForm(onSubmit: _onSubmitPost),
              )
            : Text("Main menu"),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        child: Icon(
          Icons.border_color_outlined,
          color: Colors.white,
        ),
        onPressed: () {
          if (composingMessage == true && FocusScope.of(context).hasFocus)
            FocusScope.of(context).unfocus();
          else {
            setState(() {
              composingMessage = !composingMessage;
            });
          }
        },
      ),
    );
  }
}
