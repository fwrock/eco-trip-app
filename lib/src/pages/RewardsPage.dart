import 'package:flutter/material.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prêmios e cupons de desconto'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text('Cupom de desconto - Loja Eco'),
            subtitle: Text('10% de desconto em compras'),
          ),
          ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text('Prêmio - Bicicleta Elétrica'),
            subtitle: Text('Participe do sorteio e concorra'),
          ),
          ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text('Cupom de desconto - Café Verde'),
            subtitle: Text('15% de desconto em bebidas'),
          ),
        ],
      ),
    );
  }
}
