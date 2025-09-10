import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestScreen extends StatefulWidget {
  final String testId;
  TestScreen({required this.testId});
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<Map<String, dynamic>> questions = [];
  Map<int, int> answers = {};
  int current = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final qSnap = await FirebaseFirestore.instance.collection('tests').doc(widget.testId).collection('questions').get();
    questions = qSnap.docs.map((d) => d.data()).toList();
    setState(() => loading = false);
  }

  void submit() async {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final correct = q['correctIndex'] ?? 0;
      final ans = answers[i];
      if (ans != null && ans == correct) score++;
    }
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text('Result'),
      content: Text('Score: $score / ${questions.length}'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Scaffold(body: Center(child: CircularProgressIndicator()));
    final q = questions[current];
    return Scaffold(
      appBar: AppBar(title: Text('Test')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text('Q${current + 1}: ${q['text']}'),
            ...List.generate((q['options'] as List).length, (idx) => ListTile(
              title: Text(q['options'][idx]),
              leading: Radio<int>(
                value: idx,
                groupValue: answers[current],
                onChanged: (v) { setState(() => answers[current] = v!); },
              ),
            )),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              ElevatedButton(onPressed: current > 0 ? () => setState(() => current--) : null, child: Text('Prev')),
              ElevatedButton(onPressed: current < questions.length - 1 ? () => setState(() => current++) : null, child: Text('Next')),
              ElevatedButton(onPressed: submit, child: Text('Submit')),
            ]),
          ],
        ),
      ),
    );
  }
}
