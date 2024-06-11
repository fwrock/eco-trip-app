import 'package:flutter/material.dart';

class PartnersPage extends StatelessWidget {
  const PartnersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parceiros'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Loja Eco'),
            subtitle: Text('Descontos em produtos sustentáveis'),
          ),
          ListTile(
            leading: Icon(Icons.local_cafe),
            title: Text('Café Verde'),
            subtitle: Text('Descontos em bebidas ecológicas'),
          ),
          ListTile(
            leading: Icon(Icons.local_hospital),
            title: Text('Clínica Vida'),
            subtitle: Text('Descontos em serviços de saúde'),
          ),
        ],
      ),
    );
  }
}
