import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imageColumn = "imageColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _database;

  Future<Database> get database async {
    Future<Database> initDatabase() async {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, "contact.db");

      return await openDatabase(path, version: 1,
          onCreate: (Database db, int newerVersion) async {
        await db
            .execute("CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY,"
                "$nameColumn TEXT, $nameColumn TEXT, $emailColumn TEXT,"
                "$phoneColumn TEXT, $imageColumn TEXT)");
      });
    }

    Future<Contact> saveContact(Contact contact) async {
      Database databaseContact = await database;
      contact.id = await databaseContact.insert(contactTable, contact.toMap());
      return contact;
    }

    Future<Contact> getContact(int id) async {
      Database databaseContact = await database;
      List<Map> map = await databaseContact.query(contactTable,
          columns: [
            idColumn,
            nameColumn,
            emailColumn,
            phoneColumn,
            imageColumn
          ],
          where: "$idColumn = ?",
          whereArgs: [id]);
      if (map.length > 0)
        return Contact.fromMap(map.first);
      else
        return null;
    }

    if (_database != null) {
      return _database;
    } else {
      _database = await initDatabase();
    }
  }
}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String image;

  Contact.fromMap(Map map) {
    this.id = map[idColumn];
    this.name = map[nameColumn];
    this.email = map[emailColumn];
    this.phone = map[phoneColumn];
    this.image = map[imageColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: this.name,
      emailColumn: this.email,
      phoneColumn: this.phone,
      imageColumn: this.image,
    };
    if (idColumn != null) map[idColumn] = this.id;
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, image: $image)";
  }
}
