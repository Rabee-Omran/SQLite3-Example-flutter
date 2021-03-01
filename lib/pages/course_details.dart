import 'package:flutter/material.dart';
import 'package:sqllite3example/models/course.dart';

class CourseDetails extends StatelessWidget {
  final Course course;

  const CourseDetails({this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Course Detail'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(course.name, style: Theme.of(context).textTheme.headline3),
              SizedBox(
                height: 30,
              ),
              Text(course.content,
                  style: Theme.of(context).textTheme.bodyText1),
              SizedBox(
                height: 30,
              ),
              Text(course.hours.toString(),
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
      ),
    );
  }
}
