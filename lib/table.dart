import 'package:flutter/material.dart';
import 'DataBaseHelper.dart';

final dbHelper = DatabaseHelper();

class TabelaUsuariosWidget extends StatefulWidget {
  @override
  _TabelaUsuariosWidgetState createState() => _TabelaUsuariosWidgetState();
}

class _TabelaUsuariosWidgetState extends State<TabelaUsuariosWidget> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> usuarios = [];

  @override
  void initState() {
    super.initState();
    _carregarUsuariosDoBancoDeDados();
  }

  Future<void> _carregarUsuariosDoBancoDeDados() async {
    List<Map<String, dynamic>> usuariosCarregados =
        await dbHelper.listarUsuarios();
    setState(() {
      usuarios = usuariosCarregados;
    });
  }

  void _excluirUsuario(int id) async {
    await dbHelper.deletarUsuarioPeloId(id);
    setState(() {
      usuarios = usuarios.where((user) => user['id'] != id).toList();
    });
  }

  void _editarUsuario(int id, String nome, int idade) {
    TextEditingController _controllerNome = TextEditingController(text: nome);
    TextEditingController _controllerIdade =
        TextEditingController(text: idade.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar Usuario"),
          content: Container(
            constraints: BoxConstraints(maxWidth: 300),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controllerNome,
                    decoration: InputDecoration(labelText: "Novo nome"),
                    onChanged: (text) {},
                  ),
                  TextField(
                    controller: _controllerIdade,
                    decoration: InputDecoration(labelText: "Nova idade"),
                    onChanged: (text) {},
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Salvar"),
              onPressed: () async {
                String nomeDigitado = _controllerNome.text;
                String idadeTexto = _controllerIdade.text;
                int? idadeDigitada = int.tryParse(idadeTexto);

                await dbHelper.atualizarUsuarioPeloId(
                    id, nomeDigitado, idadeDigitada);
                print("Nome: $nomeDigitado, Idade: $idadeDigitada");

                setState(() {
                  usuarios = usuarios.map((user) {
                    if (user['id'] == id) {
                      return {
                        ...user,
                        'nome': nomeDigitado,
                        'idade': idadeDigitada,
                      };
                    }
                    return user;
                  }).toList();
                });

                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabela de Usuários'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'ID',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Nome',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Idade',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> usuario = usuarios[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.green,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      _excluirUsuario(usuario['id']);
                    } else if (direction == DismissDirection.endToStart) {
                      _editarUsuario(
                          usuario['id'], usuario['nome'], usuario['idade']);
                    }
                  },
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${usuario['id']}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${usuario['nome']}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${usuario['idade']}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
