import 'package:flutter/material.dart';
import 'package:tarifuygulama/models/malzeme.dart';
import 'dbhelper.dart';
import 'models/recipe.dart';
import 'models/ingredients.dart';
import 'models/ingredient.dart';
import 'models/malzeme.dart';


class recipeDetailPage extends StatefulWidget {
  final int recipe_id;
  const recipeDetailPage({super.key, required this.recipe_id});

  @override
  State<recipeDetailPage> createState() => _recipeDetailPageState();



}

class _recipeDetailPageState extends State<recipeDetailPage> {

  late Future<List<recipe>> recipeDetail;
  late Future<List<malzeme>> malzemeler;
  late DatabaseHelper dbHepler;
  @override
  void initState(){
    super.initState();
    dbHepler=DatabaseHelper.instance;
    malzemeler=dbHepler.malzemelereiGetir(widget.recipe_id);
    recipeDetail=dbHepler.getRecipeDetails(widget.recipe_id);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarif Detaylar'),


      ),
      body: Column(
          children:
          [Divider(
            color: Colors.grey[300],
            height: 20,

          ),Expanded(
        child: FutureBuilder<List<malzeme>>(
          future: malzemeler,
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }else if(!snapshot.hasData || snapshot.data!.isEmpty){
              return Center(child: Text('Detaya gidilemedi'));
            } else if(snapshot.hasError){
              return Center(child: Text('Error ${snapshot.error}'),);
            }else{
              return ListView.builder(
                  itemCount:  snapshot.data!.length,
                  itemBuilder: (context,index){
                    var item= snapshot.data![index];
                    return ListTile(
                      title: Text(item.miktar.toString()+' '+item.ingredient_name,),

                    );
                  });
            }
          }
      ),
      ),
      Divider(
        color: Colors.grey[300],
        thickness: 1,
        height: 20,

      ),
      Expanded(
        child:FutureBuilder<List<recipe>>(
            future:recipeDetail,
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }else if(!snapshot.hasData || snapshot.data!.isEmpty){
                return Center(child: Text('Detaya gidilemedi'));
              } else if(snapshot.hasError){
                return Center(child: Text('Error ${snapshot.error}'),);
              }else{
                return ListView.builder(
                    itemCount:  snapshot.data!.length,
                    itemBuilder: (context,index){
                      var item= snapshot.data![index];
                      return ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Column(
                          children: [
                            Text(style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),item.recipe_name),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                                children:[
                                  Icon(Icons.timer),
                                  SizedBox(width: 4,) ,
                                  Text('${item.recipe_time.toString()} dakika'),
                                ]

                            ),
                            Text(item.recipe_steps.toString()),


                          ],
                        )

                      );
                    });
              }
            }
        ),
      )


    ])
    );
  }
}


