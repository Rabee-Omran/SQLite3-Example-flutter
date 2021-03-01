import 'package:flutter/material.dart';
import 'package:sqllite3example/models/course.dart';
import 'package:sqllite3example/utils/db_helper.dart';

class CourseUpdate extends StatefulWidget {
  final Course course;

  const CourseUpdate({this.course});
  @override
  _CourseUpdateState createState() => _CourseUpdateState();
}

class _CourseUpdateState extends State<CourseUpdate> {
  TextEditingController cName = TextEditingController();
  TextEditingController cContent = TextEditingController();
  TextEditingController cHours = TextEditingController();
  DbHelper helper;

  @override
  void initState() {
    helper = DbHelper();
    cName.text = widget.course.name;
    cContent.text = widget.course.content;
    cHours.text = widget.course.hours.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Update Course'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: cName,
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
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: cContent,
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
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: cHours,
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
                    Course course = Course.fromMap({
                      'id': widget.course.id,
                      'name': cName.text,
                      'content': cContent.text,
                      'hours': int.parse(cHours.text)
                    });
                    await helper.updateCourse(course).then((_) => {
                          Navigator.of(context).pop("edit"),
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
