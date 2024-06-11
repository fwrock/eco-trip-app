import 'package:flutter/material.dart';

class MyTransportPage extends StatefulWidget {
  const MyTransportPage({Key? key}) : super(key: key);

  @override
  _MyTransportPageState createState() => _MyTransportPageState();
}

class _MyTransportPageState extends State<MyTransportPage> {
  final Map<String, bool> _transportOptions = {
    'Bicicleta': false,
    'Carro elétrico': false,
    'Ônibus': false,
    'Caminhada': false,
    'Metrô': false,
    'Patinete elétrico': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus meios de transporte'),
      ),
      body: ListView(
        children: _transportOptions.keys.map((String key) {
          return CheckboxListTile(
            title: Text(key),
            value: _transportOptions[key],
            onChanged: (bool? value) {
              setState(() {
                _transportOptions[key] = value ?? false;
              });
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          // Implemente a ação ao confirmar a seleção, como salvar no banco de dados ou navegar para outra página.
          print('Transportes selecionados: ${_transportOptions}');
        },
      ),
    );
  }
}
