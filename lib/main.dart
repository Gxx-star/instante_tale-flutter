import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/database/models/book.dart';
import 'package:instant_tale/network/http.dart';
import 'package:isar/isar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppGlobals().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _isar = AppGlobals().isar;
  var _inputId = '';
  var _inputTitle = '';
  var _inputType = '';
  late Stream<List<Book>> _books;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    _inputId = value;
                  });
                },
                decoration: const InputDecoration(hintText: 'Id'),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _inputTitle = value;
                  });
                },
                decoration: const InputDecoration(hintText: 'title'),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _inputType = value;
                  });
                },
                decoration: const InputDecoration(hintText: 'type'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              await _isar.writeTxn(() async {
                await _isar.books.put(
                  Book(
                    id: int.parse(_inputId),
                    title: _inputTitle,
                    type: _inputType,
                  ),
                );
              });
            },
            child: Text('Add'),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _books,
              builder: (context, snapshot) {
                final books = snapshot.data!;
                return ListView.builder(
                  itemCount:books.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      title: Text(books[index].title),
                      subtitle: Text(books[index].type),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _books = _isar.books.where().watch(fireImmediately: true);
  }
}
