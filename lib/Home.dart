import 'package:flutter/material.dart';
import 'table.dart';
import 'Form.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página Inicial'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddUsuarioForm()),
                );
              },
              child: Text('Adicionar Usuário'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TabelaUsuariosWidget()),
                );
              },
              child: Text('Ver Tabela de Usuários'),
            ),
          ],
        ),
      ),
    );
  }
}
