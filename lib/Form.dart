import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'DataBaseHelper.dart';

final dbHelper = DatabaseHelper();

class AddUsuarioForm extends StatefulWidget {
  @override
  _AddUsuarioFormState createState() => _AddUsuarioFormState();
}

class _AddUsuarioFormState extends State<AddUsuarioForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _idadeController = TextEditingController();

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      String nome = _nomeController.text;
      int idade = int.parse(_idadeController.text);
      dbHelper.salvar(nome, idade);
      _nomeController.clear();
      _idadeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _idadeController,
                decoration: InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma idade';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
