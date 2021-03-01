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
  TextEditingController teSearch = TextEditingController();
  List<Map<String, dynamic>> allCourses = [];
  List<Map<String, dynamic>> items = [];

  DbHelper helper;

  @override
  void initState() {
    helper = DbHelper();
    helper.allCourses().then((courses) {
      setState(() {
        allCourses = courses;
        items = allCourses;
      });
    });

    super.initState();
  }

  void filterSearch(String query) async {
    // ignore: non_constant_identifier_names
    List<Map<String, dynamic>> all_courese = allCourses;
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> result = [];
      all_courese.forEach((item) {
        Course course = Course.fromMap(item);
        if (course.name.toLowerCase().contains(query.toLowerCase())) {
          result.add(item);
        }
      });
      setState(() {
        items = [];
        items = result;
      });
    } else {
      setState(() {
        items = [];
        items = allCourses;
      });
    }
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
                    items = courses;

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
            : Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.green,
                        ),
                        labelText: "Search",
                        labelStyle: TextStyle(color: Colors.green),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green, width: 1.0),
                        ),
                        hintText: "Search"),
                    controller: teSearch,
                    onChanged: (val) {
                      setState(() {
                        filterSearch(val);
                      });
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (ctx, index) {
                        Course course = Course.fromMap(items[index]);
                        return Card(
                          margin: EdgeInsets.all(5),
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      CourseDetails(course: course),
                                ),
                              );
                            },
                            title: Text(
                                '${course.name} - ${course.hours} Hours  - ${course.level} '),
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
                                                items = courses;
                                              });

                                              showSnackBar(
                                                  "Deleted Successfuly");
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
                                                await Navigator.of(context)
                                                    .push(
                                              MaterialPageRoute(
                                                builder: (ctx) => CourseUpdate(
                                                    course: course),
                                              ),
                                            );
                                            if (result == 'edit') {
                                              helper
                                                  .allCourses()
                                                  .then((courses) {
                                                setState(() {
                                                  items = courses;

                                                  showSnackBar(
                                                      "Updated Successfuly");
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
                ],
              ),
      ),
    );
  }
}

final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

showSnackBar(String msg) {
  scaffoldState.currentState.showSnackBar(new SnackBar(content: Text('$msg ')));
}
