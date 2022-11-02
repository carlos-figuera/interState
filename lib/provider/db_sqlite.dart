
import 'package:one_purina/Models/M_Login/MRegistro.dart';
import 'package:one_purina/Models/M_carrito/M_carrito.dart';
import 'package:one_purina/Utilidades/Toast_util.dart';
import 'package:sqflite/sqflite.dart';

class Db_sqlite {
  Database database;
  Future<Database> Load() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + '/carrito1.db';
    print(path);
    return database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table

      await db.execute(
          'CREATE TABLE Carrito (id INTEGER PRIMARY KEY,idproducto TEXT, brand TEXT, quantity TEXT, img TEXT,description TEXT,part_number TEXT,tipo TEXT,rated TEXT,grou TEXT,cca TEXT)');
      await db.execute(
          'CREATE TABLE usuarios (id INTEGER PRIMARY KEY,nombre TEXT, email TEXT,celular TEXT,contrasena TEXT)');
    });
    // getList();
  }



  insertUsuario(
      {String nombre,
        String email,
        String contrasena,
        String celular}) async {
    print(nombre);
    print(email);
    print(contrasena);
    print(celular);

    new Future.delayed(new Duration(seconds: 1), () async {});
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
        'INSERT INTO usuarios(nombre,email,celular,contrasena) VALUES(?,?, ?, ?)', [nombre, email, celular, contrasena],
      );
      print('inserted1: $nombre');
      /*  int id2 = await txn.rawInsert(
          'INSERT INTO Unidades(name, value, num) VALUES(?, ?, ?)',
          ['another name', 12345678, 3.1416]);*/
      //print('inserted2: $id2');
    });
    // Get the records
  }

  Future<List<MRegistro>> getListUusario() async {
    //Load();
    var loa = await Load();
    List<MRegistro> _lis_exten = new List();
    List<Map> list = await database.rawQuery('SELECT * FROM usuarios');
    if (list != null) {
      _lis_exten = list.map((model) => MRegistro.fromJson(model)).toList();
      print(list);
    }

    return _lis_exten;
  }


  Future<List<MRegistro>> existeUsuario({String email}) async {
    //Load();
    var loa = await Load();
    int count = 0;

    List<MRegistro> _lis_exten = new List();
    List<Map> list = await database.rawQuery('SELECT * FROM usuarios WHERE email = ?', [email]);
    if (list != null) {
      _lis_exten = list.map((model) => MRegistro.fromJson(model)).toList();
      print(list);
    }

    if (list != null) {
      count = list.length;
    }

    print("Encontre $count");
    return _lis_exten;
  }


  insert(
      {String id,
      String brand,
        String quantity,
      String img,
      String description,
      String part_number,String tipo,String rated,String group,String cca}) async {
    print(brand);
    print(quantity);
    print(img);
    print(description);
    print(part_number);
    new Future.delayed(new Duration(seconds: 1), () async {});
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
        'INSERT INTO Carrito(idproducto,brand,quantity, img,description,part_number,tipo,rated,grou,cca) VALUES(?,?, ?, ?, ?,?,?,?,?,?)', [id, brand, quantity, img, description, part_number,tipo,rated,group,cca],
      );
      print('inserted1: $id');
      /*  int id2 = await txn.rawInsert(
          'INSERT INTO Unidades(name, value, num) VALUES(?, ?, ?)',
          ['another name', 12345678, 3.1416]);*/
      //print('inserted2: $id2');
    });
    // Get the records
  }

  Future<List<M_Carrito>> getList() async {
    //Load();
    var loa = await Load();
    List<M_Carrito> _lis_exten = new List();
    List<Map> list = await database.rawQuery('SELECT * FROM Carrito');
    if (list != null) {
      _lis_exten = list.map((model) => M_Carrito.fromJson(model)).toList();
      print(list);
    }

    return _lis_exten;
  }

  Future<List<M_Carrito>> getOrdenes({String tipo}) async {
    //Load();
    var loa = await Load();
    int count = 0;

    List<M_Carrito> _lis_exten = new List();
    List<Map> list = await database.rawQuery('SELECT * FROM Carrito WHERE tipo = ?', [tipo]);
    if (list != null) {
      _lis_exten = list.map((model) => M_Carrito.fromJson(model)).toList();
      print(list);
    }

    if (list != null) {
      count = list.length;
    }

    print("Encontre $count");
    return _lis_exten;
  }

  Future<int> updatetCard({ M_Carrito iten_car}) async {
    Map<String, dynamic> map_update = {"idproducto": iten_car.idproducto, "brand":iten_car.brand,"quantity": iten_car.quantity,"img":iten_car.img,"description": iten_car.description,"part_number": iten_car.partNumber,"tipo": iten_car.tipo,"rated": iten_car.rated,"grou": iten_car.group,"cca":iten_car.cca};
    var loa = await Load();
    int count = await database.update(
      'Carrito', map_update,
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [iten_car.id],
    );

    /*int count = await database.rawUpdate(
        'UPDATE Unidades SET token = ?, value =$TOKEN WHERE idExtension = ?',
        [TOKEN, '9876', id]);*/
    print('updated: $count');

    return count;
  }

  Future<int> delete(int id) async {
    int count = await database
        .rawDelete('DELETE FROM Carrito WHERE id = ?', [id]);
    print(count);

    if(count==1){
      Toat_mensaje_center(color: 1,mensaje: "El producto fue eliminado." );
    }
    return count;
  }


  Future<int> delete_all({String  tipo}) async {
    int count = await database
        .rawDelete('DELETE FROM Carrito WHERE tipo = ?', [tipo]);
    print(count);
    return count;
  }
}
