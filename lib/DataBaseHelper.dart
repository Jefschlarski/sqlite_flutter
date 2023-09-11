import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
//method que recupera o local do banco de dados respectivos do ios e android e cria o arquivo db.

  Future<Database> recuperarBancoDeDados() async {
    final caminhoBancoDeDados = await getDatabasesPath();
    final localBancoDeDados = join(caminhoBancoDeDados, "banco.db");
    // INICIA O DATABASE
    var bd = await openDatabase(localBancoDeDados, version: 1,
        onCreate: (db, dbVersaoRecente) {
      String sql =
          //INTEGER VARCHAR TEXT
          "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
      //CRIA A TABELA INICIAL DO DATABASE
      db.execute(sql);
    });
    return bd;
    //print("aberto" + bd.isOpen.toString());
  }

  Future<void> salvar(nome, idade) async {
    Database bd = await recuperarBancoDeDados();
    Map<String, dynamic> dadosUsuario = {"nome": nome, "idade": idade};

    int id = await bd.insert("usuarios", dadosUsuario);
    print("salvo: $id");
    //print(verificarId(id));
  }

  Future<List<Map<String, dynamic>>> listarUsuarios() async {
    Database bd = await recuperarBancoDeDados();

    // utilize a clausula WHERE exemplo = valor para filtrar and e or para outras condições
    //String sql = "SELECT * FROM usuarios WHERE idade > 30 AND idade < 58";
    //String sql = "SELECT * FROM usuarios WHERE BETWEEN 30 AND 50";
    //String sql = "SELECT * FROM usuarios WHERE idade IN (18,30)";
    //String sql = "SELECT * FROM usuarios WHERE nome LIKE 'j%'";
    //String filtro = "ef";
    //String sql = "SELECT * FROM usuarios WHERE nome LIKE '%" + filtro + "%' ";
    //String sql = "SELECT * FROM usuarios WHERE nome LIKE 'j%'";
    String sql = "SELECT * FROM usuarios";
    List<Map<String, dynamic>> usuarios = await bd.rawQuery(sql);

    return usuarios;
//print(usuarios);
  }

  Future<List<Map<String, dynamic>>> recuperarUsuarioPeloId(id) async {
    Database bd = await recuperarBancoDeDados();

    List<Map<String, dynamic>> usuarios = await bd.query("usuarios",
        columns: ["id", "nome", "idade"], where: "id = ?", whereArgs: [id]);

    return usuarios;
  }

  Future<void> deletarUsuarioPeloId(int id) async {
    Database bd = await recuperarBancoDeDados();
    await bd.delete("usuarios", where: 'id = ?', whereArgs: [id]);
    print("deletado");
    print(verificarId(id));
  }

  Future<void> atualizarUsuarioPeloId(int id, String nome, idade) async {
    Database bd = await recuperarBancoDeDados();
    Map<String, dynamic> dadosUsuario = {"nome": nome, "idade": idade};
    bd.update("usuarios", dadosUsuario, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> verificarId(int id) async {
    Database bd = await recuperarBancoDeDados();
    List usuarios = await bd.query("usuarios",
        columns: ["id", "nome", "idade"], where: "id = ?", whereArgs: [id]);
    if (usuarios.isNotEmpty) {
      return print("usuário encontrado com o ID $id");
    } else {
      return print("Nenhum usuário encontrado com o ID $id");
    }
  }
}
