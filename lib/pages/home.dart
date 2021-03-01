import 'package:flutter/material.dart';
import 'package:sqllite3example/models/course.dart';
import 'package:sqllite3example/utils/db_helper.dart';

import 'course_details.dart';
import 'course_update.dart';
import 'new_course.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Course> items = new List();

  DbHelper helper;

  @override
  void initState() {
    helper = DbHelper();
    helper.allCourses().then((courses) {
      setState(() {
        courses.forEach((course) {
          items.add(Course.fromMap(course));
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('SQLite Database Example'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              String result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => Newcourse(),
                ),
              );
              if (result == 'save') {
                helper.allCourses().then((courses) {
                  setState(() {
                    items.clear();
                    courses.forEach((course) {
                      items.add(Course.fromMap(course));
                    });
                    showSnackBar("Added Successfuly");
                  });
                });
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: (items == null)
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, index) {
                  Course course = Course.fromMap(items[index].toMap());
                  return Card(
                    margin: EdgeInsets.all(5),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => CourseDetails(course: course),
                          ),
                        );
                      },
                      title: Text('${course.name} - ${course.hours} Hours'),
                      subtitle: Text(
                        course.content,
                        style: TextStyle(fontSize: 10),
                      ),
                      trailing: Container(
                        width: 100,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      helper.deleteCourse(course.id);

                                      helper.allCourses().then((courses) {
                                        setState(() {
                                          items.clear();
                                          courses.forEach((course) {
                                            items.add(Course.fromMap(course));
                                          });
                                        });
                                      });
                                    });
                                  },
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                    onPressed: () async {
                                      String result =
                                          await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              CourseUpdate(course: course),
                                        ),
                                      );
                                      if (result == 'edit') {
                                        helper.allCourses().then((courses) {
                                          setState(() {
                                            items.clear();
                                            courses.forEach((course) {
                                              items.add(Course.fromMap(course));
                                            });
                                            showSnackBar("Updated Successfuly");
                                          });
                                        });
                                      }
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

showSnackBar(String msg) {
  scaffoldState.currentState.showSnackBar(new SnackBar(content: Text('$msg ')));
}
