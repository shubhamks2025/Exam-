import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'test_screen.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tests').snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) return Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (ctx, i) {
              final t = docs[i];
              return ListTile(
                title: Text(t['name'] ?? 'Test'),
                subtitle: Text('Duration: ${t['duration']} mins'),
                trailing: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TestScreen(testId: t.id))),
                  child: Text('Start')
                ),
              );
            },
          );
        },
      ),
    );
  }
}
