import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestFirestore extends StatefulWidget {
  const TestFirestore({super.key});

  @override
  State<TestFirestore> createState() => TestFirestoreState();
}

class TestFirestoreState extends State<TestFirestore> {
  var db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Database"),
      ),
      
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        
        stream: db.collection("users").snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshots.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }

          //OLAH DATA
          var _data = snapshots.data!.docs;

          return ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context, Index) {
              return ListTile(
                onLongPress: () {
                  _data[Index].reference.delete().then((value) =>
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Data Terhapus"))));
                },
                subtitle: Text(_data[Index].data()['born'].toString()),
                title: Text(_data[Index].data()['first'] +
                    ' ' +
                    _data[Index].data()['last']),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create a new user with a first and last name
          final user = <String, dynamic>{
            "first": "Clalalala",
            "last": "Syahlalala",
            "born": 2070
          };

// Add a new document with a generated ID
          db.collection("users").add(user).then((DocumentReference doc) =>
              print('DocumentSnapshot added with ID: ${doc.id}'));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
