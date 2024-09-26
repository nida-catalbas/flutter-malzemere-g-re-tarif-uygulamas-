import 'package:flutter/material.dart';
import 'dbhelper.dart';
import 'models/recipe.dart';
import 'recipedetail.dart';

class allRecipes extends StatefulWidget {
  const allRecipes({super.key});

  @override
  State<allRecipes> createState() => _allRecipesState();
}

class _allRecipesState extends State<allRecipes> {


  late DatabaseHelper dbHelper;
  late Future<List<recipe>> allRecipes;
  @override
  void initState(){
    super.initState();
    dbHelper=DatabaseHelper.instance;
    allRecipes=dbHelper.getAllRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tüm Tarifler'),
      ),
      body: FutureBuilder<List<recipe>>(
          future: allRecipes,
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
      ),
    );
  }
}

