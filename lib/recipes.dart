import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tarifuygulama/dbhelper.dart';
import 'package:tarifuygulama/recipedetail.dart';
import 'models/recipe.dart';



class recipesPage extends StatefulWidget {

  final List<String> malzemeler;
  const recipesPage({super.key, required this.malzemeler});


  @override
  State<recipesPage> createState() => _recipesPageState();

}

class _recipesPageState extends State<recipesPage> {

  late DatabaseHelper dbHelper;
  late Future<List<recipe>> Tarifler;
  @override
  void initState(){
    print('recipes init state');
    print(widget.malzemeler);
    super.initState();
    dbHelper=DatabaseHelper.instance;
    Tarifler=dbHelper.uygunTarifler(widget.malzemeler);



  }









  void _openRecipeDetail(int recipe_id) async{
    Navigator.push(
          context, MaterialPageRoute(
          builder: (context)=> recipeDetailPage(recipe_id: recipe_id)));


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Malzemelere göre Tarif Listesi'),
        shadowColor: Colors.black,

      ),
      body:
        FutureBuilder<List<recipe>>(
            future: Tarifler,
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }else if(!snapshot.hasData || snapshot.data!.isEmpty){
                return Center(child: Text('Tahmin bulunmadı'));
              } else if(snapshot.hasError){
                return Center(child: Text('Error ${snapshot.error}'),);
              }else{
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                  var item = snapshot.data![index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => recipeDetailPage(recipe_id: item.recipe_id),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          children: [


                            SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.recipe_name,

                                  ),
                                  SizedBox(height: 4.0),


                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
              });
            }
            }
        )

    );
  }
}
