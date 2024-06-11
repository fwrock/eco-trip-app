import 'package:flutter/material.dart';

class EcoRankPage extends StatelessWidget {
  final List<Map<String, dynamic>> ecoRankings = [
    {'name': 'Alice', 'points': 1500},
    {'name': 'Bob', 'points': 1300},
    {'name': 'Charlie', 'points': 1200},
    {'name': 'David', 'points': 1000},
    {'name': 'Eve', 'points': 900},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eco Rank'),
      ),
      body: ListView.builder(
        itemCount: ecoRankings.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildTopRankItem(context, ecoRankings[index], index + 1, Colors.yellow);
          } else if (index == 1) {
            return _buildTopRankItem(context, ecoRankings[index], index + 1, Colors.grey);
          } else if (index == 2) {
            return _buildTopRankItem(context, ecoRankings[index], index + 1, Colors.brown);
          } else {
            return _buildRankItem(context, ecoRankings[index], index + 1);
          }
        },
      ),
    );
  }

  Widget _buildTopRankItem(BuildContext context, Map<String, dynamic> user, int rank, Color medalColor) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: medalColor,
        child: Text(
          rank.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(user['name']),
      subtitle: Text('${user['points']} pontos'),
      tileColor: medalColor.withOpacity(0.2),
    );
  }

  Widget _buildRankItem(BuildContext context, Map<String, dynamic> user, int rank) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          rank.toString(),
        ),
      ),
      title: Text(user['name']),
      subtitle: Text('${user['points']} pontos'),
    );
  }
}
