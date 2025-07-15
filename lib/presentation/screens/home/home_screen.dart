import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Gimini'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.pink,
              child: Icon(Icons.person),
            ),
            title: const Text('Prompt basico a Gimini'),
            subtitle: const Text('Usando el modelo Flash'),
            onTap: () => context.push('/basic-prompt'),
          )
        ],
      ),
    );
  }
}
