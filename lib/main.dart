import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dbhelper.dart';
import 'recipes.dart';
import 'allrecipes.dart';

void main() {
  runApp(const TarifUygulama());

}

class TarifUygulama extends StatelessWidget {
  const TarifUygulama({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     title: 'Tarif Uygulaması',
      home: const MyHomePage(title:'Tarif Uygulaması'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _malzemeler= [];
  final TextEditingController _controller= TextEditingController();
  late DatabaseHelper dbHelper;

  void _malzemeEkle(){
    setState(() {
      if(_controller.text.isNotEmpty){
        _malzemeler.add(_controller.text);
        _controller.clear();
      }

    });
  }


  void _malzemeSil(int index){
    setState(() {
      _malzemeler.removeAt(index);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Container(
              width: 50,
              height: 60,
              alignment: Alignment.bottomCenter,
              child:IconButton(
                icon: const Icon(Icons.list),
                onPressed: () {
                  print(
                    'tüm tarifler',
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => allRecipes(),
                    ),
                  );
                },
              ),
              )
        ],

      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Malzemeleri girin',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20,
            ),
            ElevatedButton(onPressed: (){
              _malzemeEkle();
              print('malzemeler listeye girecek');
            }, child:Text('Malzemeleri listeye at')
            ),
            SizedBox( height: 15,),
            Expanded(child:
            ListView.builder(
              itemCount: _malzemeler.length,
              itemBuilder: (context,index){
                return ListTile(
                  title: Text(_malzemeler[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _malzemeSil(index);
                    },
                  ),
                );
              },
            )
            ),


            ElevatedButton(
                style:ElevatedButton.styleFrom(
                  elevation: 4,
                  shape: const StadiumBorder(),
                  side: const BorderSide( color: Colors.green, width: 2),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.green,

            ),onPressed: (){
              print('uygun tarifleri bul');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => recipesPage(malzemeler: _malzemeler),
                ),
              );
            }, child: Text('Uygun Tarifleri Bul',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 24,
            ),
            )
            )
          ],
        ),
      ),
    );
  }
}


