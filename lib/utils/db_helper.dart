import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqllite3example/models/course.dart';

class DbHelper {
  static Database _db;

  Future<Database> createDatabase() async {
    if (_db != null) {
      return _db;
    } else {
      //define path to database
      String path = join(await getDatabasesPath(), 'school.db');
      return _db = await openDatabase(path,
          version: 2, onCreate: onCreate, onUpgrade: onUpgrade);
    }
  }

  onCreate(Database db, int v) {
    //create table
    db.execute('''
              create table courses(
               id integer primary key autoincrement,
               name varchar(50),
               content varchar(255),
               hours integer
              )''');
    return _db;
  }

//execute when i update the version of db
  onUpgrade(Database db, int old_version, int new_version) async {
    if (old_version < new_version) {
      await db.execute("alter table courses add column level varchar(50)");
    }
  }

//create course
  Future<int> createCourse(Course course) async {
    Database db = await createDatabase();

    return db.insert('courses', course.toMap());
  }

//get all courses
  Future<List> allCourses() async {
    Database db = await createDatabase();
    return await db.query(
      'courses',
    );
  }

//delete single course
  Future<int> deleteCourse(int id) async {
    Database db = await createDatabase();
    // return db.delete('courses', where: 'id=? and name = ?', whereArgs: [id,name]);
    return await db.delete('courses', where: 'id=?', whereArgs: [id]);
  }

  //update single course
  Future<int> updateCourse(Course course) async {
    Database db = await createDatabase();
    return await db.update('courses', course.toMap(),
        where: 'id=?', whereArgs: [course.id]);
  }
}
