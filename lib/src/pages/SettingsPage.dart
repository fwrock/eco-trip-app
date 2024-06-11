import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Idioma'),
            subtitle: Text('Português'),
            onTap: () {
              // Implement language selection
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notificações'),
            subtitle: Text('Ativado'),
            onTap: () {
              // Implement notification settings
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacidade'),
            subtitle: Text('Política de Privacidade'),
            onTap: () {
              // Implement privacy policy view
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Ajuda'),
            subtitle: Text('Central de Ajuda'),
            onTap: () {
              // Implement help center
            },
          ),
        ],
      ),
    );
  }
}
