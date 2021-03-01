import 'package:flutter/material.dart';
import 'package:sqllite3example/models/course.dart';
import 'package:sqllite3example/utils/db_helper.dart';

class Newcourse extends StatefulWidget {
  @override
  _NewcourseState createState() => _NewcourseState();
}

class _NewcourseState extends State<Newcourse> {
  String name, content;
  int hours;
  DbHelper helper;

  @override
  void initState() {
    helper = DbHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Add New Course'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.greenAccent, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.0),
                    ),
                    hintText: "Enter Course name",

                    // set border width
                  ),
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLines: 10,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 1.0),
                      ),
                      hintText: "Enter Course Content"),
                  onChanged: (val) {
                    setState(() {
                      content = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 1.0),
                      ),
                      hintText: "Enter Course Hours"),
                  onChanged: (val) {
                    setState(() {
                      hours = int.parse(val);
                    });
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                RaisedButton(
                  textColor: Colors.white,
                  elevation: 3,
                  splashColor: Colors.greenAccent,
                  color: Colors.green,
                  child: Text("Save"),
                  onPressed: () async {
                    Course course = Course.fromMap(
                        {'name': name, 'content': content, 'hours': hours});
                    await helper.createCourse(course).then((_) => {
                          Navigator.of(context).pop("save"),
                          showSnackBar(),
                        });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

showSnackBar() {
  scaffoldState.currentState
      .showSnackBar(new SnackBar(content: Text('Added Successfuly')));
}
