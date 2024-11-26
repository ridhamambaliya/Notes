import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class My_DB {

  // Table Note
  static final String Table_Note = "note";
  // Column of Note
  static final String Note_Column_Id = "note_no";
  static final String Note_Column_Title = "note_title";
  static final String Note_Column_Desc = "note_description";

  Future<Database> openDB() async{
    return await openDatabase(
      join(await getDatabasesPath(),'notedb.db'),
        version: 1,
        onCreate: (db, version) async{
      await db.execute(
          '''
          CREATE TABLE $Table_Note(
          $Note_Column_Id INTEGER PRIMARY KEY AUTOINCREMENT, 
          $Note_Column_Title TEXT NOT NULL, 
          $Note_Column_Desc TEXT NOT NULL
          );
          '''
      );
    });
  }

  Future<List<Map<String,dynamic>>> getAllNote() async {
    var db = await openDB();
    List<Map<String, dynamic>> Product_List = await db.query(Table_Note);
    return Product_List;
  }

  Future<bool> addNote({
    required String N_title,
    required String N_desc
  }) async {
    Database db=await openDB();
    int rowsEffected=await db.insert(Table_Note, {
      Note_Column_Title : N_title,
      Note_Column_Desc : N_desc,
    });
    return rowsEffected > 0;
  }

  Future<bool> updateNote({
    required int ID,
    required String N_title,
    required String N_desc,
  }) async {
    Database db=await openDB();
    int rowsEffected=await db.update(Table_Note, {
      Note_Column_Title : N_title,
      Note_Column_Desc : N_desc,
    }, where : "${Note_Column_Id} = ?", whereArgs : [ID]);
    return rowsEffected > 0;
  }

  Future<bool> deleteProduct({required int ID}) async {
    Database db=await openDB();
    int rowsEffected = await db.delete(Table_Note,
        where: "${Note_Column_Id} = ?", whereArgs: [ID]);
    print({'deleted', rowsEffected});
    return rowsEffected > 0;
  }

}
