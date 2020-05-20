
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/Services.dart';
import 'dart:async';
import 'json2.dart';
import 'dart:convert';
import 'Services.dart';


class getjson extends StatefulWidget {
  getjson({Key key}) : super(key: key);
  @override
  _getjsonState createState() => _getjsonState();
}
class _getjsonState extends State<getjson> {
  Future<List<QuizQuestion>> futureAlbum;

  @override
  void initState() {
    super.initState();
    try {
      futureAlbum = getdata();
    }
    catch(e){
      //error
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QuizQuestion>>(
        future: futureAlbum,
        builder: (context, snapshot) {
          List mydata = snapshot.data; //json.decode(snapshot.data.toString());
          if (mydata == null) {
            return Scaffold(
              body: Center(
                child: Text(
                  "Loading",
                ),
              ),
            );}
          else{
            return quizpage(mydata : mydata);
          }
        },
    );
  }
}
class quizpage extends StatefulWidget {
  var mydata;
  quizpage({Key key, @required this.mydata}) : super(key: key);
  _quizpageState createState() => _quizpageState(mydata);
}
class _quizpageState extends State<quizpage> {
  var mydata;
  _quizpageState(this.mydata);

  Color colortoshow = Colors.indigoAccent;
  Color right = Colors.green;
  Color wrong = Colors.red;
  int marks = 0;
  int i = 0;
  int timer = 10;
  String showtimer = "10";

  Map<int,Color> btncolor = {
    0 : Colors.indigoAccent,
    1 : Colors.indigoAccent,
    2 : Colors.indigoAccent,
    3 : Colors.indigoAccent,
  };

  bool canceltimer = false;

  @override
  void initState(){
    starttimer();
    super.initState();
  }

  void starttimer() async{
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          nextquestion();
        }
        else if (canceltimer == true) {
          t.cancel();
        }
        else {
          timer = timer - 1;
        }
        showtimer = timer.toString();
      });
    });

}

  void nextquestion(){
    canceltimer = false;
    timer=10;
    setState(() {
      if(i<mydata.length){
        i++;
      }
      else{

      }
      btncolor[0] = Colors.indigoAccent;
      btncolor[1] = Colors.indigoAccent;
      btncolor[2] = Colors.indigoAccent;
      btncolor[3] = Colors.indigoAccent;
    });
    starttimer();
  }

  void checkanswer(int k){
      if(mydata[0].answers[k].isTrue == true){
        marks=marks+1;
        colortoshow = right;
      }
      else{
        colortoshow=wrong;
      }
      setState(() {
        btncolor[k] = colortoshow;
        canceltimer=true;
      });
      Timer(Duration(seconds: 1),nextquestion);
  }

  Widget choicebutton(int k){
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: () => checkanswer(k),
        child: Text(
          mydata[i].answers[k].answers,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "",
            fontSize: 16.0,
          ),
          maxLines: 1,
        ),
        color: btncolor[k],
        splashColor: Colors.indigo[700],
        highlightColor: Colors.indigo[700],
        minWidth: 200.0,
        height: 45.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,DeviceOrientation.portraitUp
    ]);
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                "Quizapp",
              ),
              content: Text("You Can't Go Back At This Stage."),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Ok',
                  ),
                )
              ],
            ));
      },
      child: Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(15.0),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    mydata[i].questions,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "",
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      choicebutton(0),
                      choicebutton(1),
                      choicebutton(2),
                      choicebutton(3),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex:1,
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Center(
                    child: Text(
                      showtimer,
                      style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: ""
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}
